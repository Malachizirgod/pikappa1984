// Mobile nav toggle
const toggle = document.getElementById('nav-toggle');
const mobileNav = document.getElementById('nav-mobile');
if (toggle && mobileNav) {
  toggle.addEventListener('click', () => {
    mobileNav.classList.toggle('open');
  });
}

// Set active nav link
const links = document.querySelectorAll('.nav-links a, #nav-mobile a');
links.forEach(link => {
  if (link.href === window.location.href || 
      link.getAttribute('href') === window.location.pathname.split('/').pop()) {
    link.classList.add('active');
  }
});
