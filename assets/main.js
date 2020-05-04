---
layout: nil
---

var target = document.getElementsByClassName("sticky-top")[0];

document.onscroll = function(e){
  var percent = Math.max(document.body.scrollTop, document.documentElement.scrollTop) / 100;

  if (percent > 0.95) { percent = 0.95; }
  if (percent < 0) { percent = 0.0; }

  target.style.backgroundColor = 'rgba(255, 255, 255, ' + percent + ')';
};
