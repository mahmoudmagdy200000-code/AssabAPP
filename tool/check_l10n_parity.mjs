import fs from 'node:fs';

const en = JSON.parse(fs.readFileSync('lib/l10n/intl_en.arb', 'utf8'));
const ar = JSON.parse(fs.readFileSync('lib/l10n/intl_ar.arb', 'utf8'));
const keys = Object.keys(en).filter((key) => !key.startsWith('@'));
const missing = keys.filter((key) => !(key in ar));
const extra = Object.keys(ar).filter(
  (key) => !key.startsWith('@') && !(key in en),
);
const placeholders = (value) =>
  [...value.matchAll(/\{[^{}]+\}/g)].map(([match]) => match).sort();
const mismatchedPlaceholders = keys.filter(
  (key) =>
    key in ar &&
    JSON.stringify(placeholders(en[key])) !==
      JSON.stringify(placeholders(ar[key])),
);

console.log(
  JSON.stringify(
    {
      english: keys.length,
      arabic: Object.keys(ar).filter((key) => !key.startsWith('@')).length,
      missing,
      extra,
      mismatchedPlaceholders,
    },
    null,
    2,
  ),
);
if (missing.length || extra.length || mismatchedPlaceholders.length) {
  process.exitCode = 1;
}
