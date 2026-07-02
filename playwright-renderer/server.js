const express = require('express');
const { chromium } = require('playwright');

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/health', (_req, res) => res.send('ok'));

app.get('/render', async (req, res) => {
  const { url, js_render } = req.query;
  if (!url) return res.status(400).send('missing url');

  let browser;
  try {
    browser = await chromium.launch({
      headless: true,
      args: ['--no-sandbox', '--disable-gpu', '--disable-dev-shm-usage'],
    });
    const page = await browser.newPage({ viewport: { width: 1920, height: 1080 } });
    await page.goto(url, { waitUntil: 'domcontentloaded', timeout: 30000 });

    if (js_render === '1') {
      await page.waitForLoadState('networkidle', { timeout: 15000 }).catch(() => {});
    }

    const html = await page.content();
    res.send(html);
  } catch (err) {
    res.status(502).send(`render error: ${err.message}`);
  } finally {
    if (browser) await browser.close();
  }
});

app.listen(PORT, () => console.log(`playwright-renderer on :${PORT}`));
