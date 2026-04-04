// Shared nav and footer injected by each page
function getNav(activePage) {
  const pages = [
    {href:'index.html', label:'Home'},
    {href:'about.html', label:'About Alpha'},
    {href:'chapter.html', label:'Pi Kappa'},
    {href:'gallery.html', label:'Gallery'},
    {href:'memoriam.html', label:'In Memoriam'},
    {href:'service.html', label:'Service'},
    {href:'contact.html', label:'Contact'},
  ];
  const links = pages.map(p =>
    `<li><a href="${p.href}" ${p.href===activePage?'class="active"':''}>${p.label}</a></li>`
  ).join('');
  const mobileLinks = pages.map(p =>
    `<a href="${p.href}" ${p.href===activePage?'class="active"':''}>${p.label}</a>`
  ).join('');
  return `
<nav>
  <a class="nav-logo" href="index.html">
    <img src="assets/logo.png" alt="Pi Kappa Chapter Logo">
    <div class="nav-logo-text">Pi Kappa Chapter
      <span>Alpha Phi Alpha Fraternity, Inc.</span>
    </div>
  </a>
  <ul class="nav-links">${links}</ul>
  <button class="nav-toggle" id="nav-toggle" aria-label="Menu">
    <span></span><span></span><span></span>
  </button>
</nav>
<div class="nav-mobile" id="nav-mobile">${mobileLinks}</div>`;
}

function getFooter() {
  return `
<footer>
  <div class="footer-logo-block">
    <img src="assets/logo.png" alt="Pi Kappa Logo">
    <div class="footer-brand">Pi Kappa Chapter</div>
    <p class="footer-text">Alpha Phi Alpha Fraternity, Inc.<br>California State University, Northridge<br>Est. 1984 &mdash; The HollyWOOD Chapter</p>
  </div>
  <div class="footer-col">
    <h4>Navigate</h4>
    <ul class="footer-links">
      <li><a href="index.html">Home</a></li>
      <li><a href="about.html">About Alpha</a></li>
      <li><a href="chapter.html">Pi Kappa</a></li>
      <li><a href="gallery.html">Gallery</a></li>
      <li><a href="memoriam.html">In Memoriam</a></li>
    </ul>
  </div>
  <div class="footer-col">
    <h4>Chapter</h4>
    <ul class="footer-links">
      <li><a href="service.html">Service</a></li>
      <li><a href="contact.html">Contact</a></li>
    </ul>
  </div>
  <div class="footer-col">
    <h4>Connect</h4>
    <ul class="footer-links">
      <li><a href="https://www.instagram.com/csunalphas/" target="_blank">Instagram</a></li>
      <li><a href="https://apa1906.net" target="_blank">apa1906.net</a></li>
    </ul>
  </div>
</footer>
<div class="footer-bottom">
  <span class="footer-copy">&copy; Pi Kappa Chapter, Alpha Phi Alpha Fraternity, Inc.</span>
  <span class="footer-motto">&ldquo;First of All, Servants of All, We Shall Transcend All&rdquo;</span>
</div>`;
}
