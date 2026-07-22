const express = require('express');
const { chromium } = require('playwright');

const app = express();
const PORT = process.env.PORT || 3000;
const MAX_RENDERS = 50;
const MAX_AGE_MS = 30 * 60 * 1000;
const SHUTDOWN_TIMEOUT_MS = 30 * 1000;

let currentBrowser = null;
let launchPromise = null;
let refCount = 0;
let renderCount = 0;
let launchedAt = 0;
let shuttingDown = false;

function launchBrowser() {
  return chromium.launch({
    headless: true,
    args: ['--no-sandbox', '--disable-gpu', '--disable-dev-shm-usage', '--single-process'],
  });
}

async function getBrowser() {
  if (shuttingDown) throw new Error('shutting down');
  if (currentBrowser && !currentBrowser.isConnected()) {
    try { await currentBrowser.close(); } catch {}
    currentBrowser = null;
  }
  if (currentBrowser) {
    refCount++;
    return currentBrowser;
  }
  if (!launchPromise) {
    launchPromise = launchBrowser().then(b => {
      currentBrowser = b;
      renderCount = 0;
      launchedAt = Date.now();
      launchPromise = null;
      return b;
    }).catch(err => {
      launchPromise = null;
      throw err;
    });
  }
  const b = await launchPromise;
  refCount++;
  return b;
}

function releaseBrowser() {
  refCount--;
  if (refCount > 0 || !currentBrowser) return;
  const shouldRetire = renderCount >= MAX_RENDERS || (Date.now() - launchedAt) >= MAX_AGE_MS;
  if (!shouldRetire) return;
  const b = currentBrowser;
  currentBrowser = null;
  b.close().catch(() => {});
}

app.get('/health', (_req, res) => {
  const ok = currentBrowser ? currentBrowser.isConnected() : false;
  res.json({ ok, browser: ok });
});

app.get('/render', async (req, res) => {
  const { url, js_render } = req.query;
  if (!url) return res.status(400).send('missing url');

  let browser;
  try {
    browser = await getBrowser();
  } catch (err) {
    return res.status(502).send(`launch error: ${err.message}`);
  }

  let context;
  try {
    context = await browser.newContext({ viewport: { width: 1920, height: 1080 } });
    const page = await context.newPage();
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });
    if (js_render === '1') {
      await page.waitForLoadState('networkidle', { timeout: 15000 }).catch(() => {});
    }
    const html = await page.content();
    res.send(html);
  } catch (err) {
    res.status(502).send(`render error: ${err.message}`);
  } finally {
    if (context) await context.close().catch(() => {});
    renderCount++;
    releaseBrowser();
  }
});

async function shutdown() {
  shuttingDown = true;
  console.log('shutting down...');
  if (currentBrowser) {
    const b = currentBrowser;
    currentBrowser = null;
    if (refCount > 0) {
      await Promise.race([
        new Promise(resolve => {
          const check = () => {
            if (refCount === 0) return resolve();
            setTimeout(check, 100);
          };
          check();
        }),
        new Promise(resolve => setTimeout(resolve, SHUTDOWN_TIMEOUT_MS)),
      ]);
    }
    await b.close().catch(() => {});
  }
  process.exit(0);
}

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);

app.listen(PORT, () => console.log(`playwright-renderer on :${PORT}`));
