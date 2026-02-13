import { chromium } from 'playwright';

const cards = [
  ['#pkb-card', 'pkb.png'],
  ['#vrsn-card', 'vrsn.png'],
  ['#pair-card', 'pair.png'],
  ['#plex2pl-card', 'plex2pl.png'],
];

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: { width: 1600, height: 2200 } });

await page.goto('file:///work/img/cards.html', { waitUntil: 'networkidle' });
await page.waitForLoadState('domcontentloaded');
await page.waitForFunction(() => document.fonts && document.fonts.status === 'loaded');
await page.addStyleTag({
  content: `
    html, body {
      background: transparent !important;
    }
  `,
});

for (const [selector, output] of cards) {
  const locator = page.locator(`${selector} repo-card`);
  await locator.waitFor({ state: 'visible' });
  await locator.screenshot({
    path: `/work/img/${output}`,
    omitBackground: true,
  });

  console.log(`wrote img/${output}`);
}

await browser.close();
