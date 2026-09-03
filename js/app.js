/* ─────────────────────────────────────────────────────────────
   app.js — Datatypes reference
   Loads JSON data and renders tabs + search for each DB.
───────────────────────────────────────────────────────────────*/

const DBS = [
  { key: 'mysql',    label: 'MySQL',      icon: 'MY', file: 'data/mysql.json' },
  { key: 'oracle',   label: 'Oracle',     icon: 'OR', file: 'data/oracle.json' },
  { key: 'postgres', label: 'PostgreSQL', icon: 'PG', file: 'data/postgres.json' }
];

// ── Build badge class from category key ──────────────────────
function badgeClass(cat) {
  const map = {
    num: 'badge-num', str: 'badge-str', date: 'badge-date',
    bool: 'badge-bool', bin: 'badge-bin', json: 'badge-json',
    spec: 'badge-spec', lob: 'badge-lob', xml: 'badge-xml',
    net: 'badge-net', geo: 'badge-geo', obs: 'badge-obs'
  };
  return map[cat] ?? 'badge-spec';
}

// ── Escape HTML to prevent XSS ───────────────────────────────
function esc(str) {
  return str.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

// ── Render one panel from JSON data ──────────────────────────
function renderPanel(data, key) {
  const panel = document.getElementById(`panel-${key}`);
  if (!panel) return;

  let rows = '';
  for (const cat of data.categories) {
    rows += `<tr class="cat-row"><td colspan="4">${esc(cat.label)}</td></tr>`;
    for (const t of cat.types) {
      rows += `
        <tr class="data-row" data-search="${esc(t.type + ' ' + t.uso + ' ' + t.badge).toLowerCase()}">
          <td><code>${esc(t.type)}</code></td>
          <td><span class="badge ${badgeClass(t.cat)}">${esc(t.badge)}</span></td>
          <td>${esc(t.uso)}</td>
          <td><code>${esc(t.ejemplo)}</code></td>
        </tr>`;
    }
  }

  panel.querySelector('tbody').innerHTML = rows;

  // store total for stats
  const total = data.categories.reduce((n, c) => n + c.types.length, 0);
  panel.dataset.total = total;
  updateStats(key, total, total);
}

// ── Update stats bar ─────────────────────────────────────────
function updateStats(key, visible, total) {
  const el = document.getElementById(`stats-${key}`);
  if (!el) return;
  el.textContent = visible === total
    ? `${total} tipos de datos`
    : `${visible} de ${total} tipos`;
}

// ── Filter rows on search input ───────────────────────────────
function filterTable(key, query) {
  const panel   = document.getElementById(`panel-${key}`);
  const rows    = panel.querySelectorAll('tbody tr');
  const q       = query.trim().toLowerCase();
  const total   = Number(panel.dataset.total ?? 0);
  const empty   = panel.querySelector('.empty-state');
  let visible   = 0;
  let lastCat   = null;

  rows.forEach(row => {
    if (row.classList.contains('cat-row')) {
      lastCat = row;
      row.classList.add('hidden');
    } else {
      const match = !q || row.dataset.search.includes(q);
      row.classList.toggle('hidden', !match);
      if (match) {
        visible++;
        if (lastCat) lastCat.classList.remove('hidden');
      }
    }
  });

  if (empty) empty.style.display = visible === 0 ? 'block' : 'none';
  updateStats(key, visible, total);
}

// ── Build static shell for a panel ───────────────────────────
function buildShell(db) {
  const panel = document.getElementById(`panel-${db.key}`);
  panel.innerHTML = `
    <div class="search-wrap">
      <span class="search-icon">🔍</span>
      <input
        id="search-${db.key}"
        class="search-box"
        type="text"
        placeholder="Buscar tipo de dato, categoría o uso..."
        autocomplete="off"
      >
    </div>
    <div class="stats" id="stats-${db.key}">Cargando…</div>
    <div class="table-wrap">
      <table class="db-table" id="table-${db.key}">
        <thead>
          <tr>
            <th>Tipo</th>
            <th>Categoría</th>
            <th>Uso</th>
            <th>Ejemplo</th>
          </tr>
        </thead>
        <tbody></tbody>
      </table>
      <div class="empty-state">No se encontraron tipos de datos para "<span id="empty-q-${db.key}"></span>"</div>
    </div>`;

  document.getElementById(`search-${db.key}`)
    .addEventListener('input', e => {
      document.getElementById(`empty-q-${db.key}`).textContent = e.target.value;
      filterTable(db.key, e.target.value);
    });
}

// ── Tab switching ─────────────────────────────────────────────
function switchTab(key) {
  document.querySelectorAll('.tab-btn').forEach(b =>
    b.classList.toggle('active', b.dataset.tab === key));
  document.querySelectorAll('.tab-panel').forEach(p =>
    p.classList.toggle('active', p.id === `panel-${key}`));
}

// ── Init ──────────────────────────────────────────────────────
async function init() {
  const nav = document.getElementById('tab-nav');

  for (const db of DBS) {
    // Tab button
    const btn = document.createElement('button');
    btn.className   = 'tab-btn';
    btn.dataset.tab = db.key;
    btn.innerHTML   = `<span class="db-icon ${db.key}">${db.icon}</span><span class="label">${db.label}</span>`;
    btn.addEventListener('click', () => switchTab(db.key));
    nav.appendChild(btn);

    // Panel
    const panel       = document.createElement('div');
    panel.id          = `panel-${db.key}`;
    panel.className   = 'tab-panel';
    document.getElementById('panels').appendChild(panel);

    buildShell(db);
  }

  // activate first tab
  switchTab(DBS[0].key);

  // fetch all JSON files in parallel
  const results = await Promise.all(
    DBS.map(db =>
      fetch(db.file)
        .then(r => r.json())
        .catch(() => null)
    )
  );

  results.forEach((data, i) => {
    if (data) renderPanel(data, DBS[i].key);
    else {
      const s = document.getElementById(`stats-${DBS[i].key}`);
      if (s) s.textContent = 'Error al cargar datos.';
    }
  });
}

document.addEventListener('DOMContentLoaded', init);
