# Pi Kappa Chapter — Official Website
**Alpha Phi Alpha Fraternity, Inc. | The HollyWOOD Chapter | Est. 1984**

Live at: [pikappa1984.online](https://pikappa1984.online)

## Pages
- `index.html` — Homepage
- `about.html` — About Alpha Phi Alpha
- `chapter.html` — Pi Kappa Lineage (34 lines, all brothers)
- `memoriam.html` — In Memoriam
- `service.html` — Service & Programs
- `contact.html` — Contact / Membership

## Assets
- `assets/style.css` — Global styles
- `assets/components.js` — Shared nav and footer
- `assets/logo.png` — Pi Kappa Chapter logo
- `assets/anniversary.jpg` — 40th Anniversary photo

## To deploy
1. Push to GitHub repo `Malachizirgod/pikappa1984` (or any repo name)
2. Go to Settings → Pages → set source to main branch
3. Add custom domain: pikappa1984.online
4. Check Enforce HTTPS

## To add a new line to the lineage
Open `chapter.html`, find the `lines` array in the `<script>` tag, and add a new entry at the end following the same format.

## To add a memoriam photo
Open `memoriam.html`, find the brother's card, replace the `photo-placeholder` div with:
`<img class="brother-photo" src="YOUR_URL" alt="Brother Name">`
