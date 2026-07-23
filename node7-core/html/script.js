const resource = typeof GetParentResourceName === 'function' ? GetParentResourceName() : 'node7-core';
const $ = id => document.getElementById(id);
const post = (name, data = {}) => fetch(`https://${resource}/${name}`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data)
}).then(r => r.json());

const state = { inventory: null, progressTimer: null };

function visible(id, show) {
    const el = $(id);
    if (el) el.classList.toggle('hidden', !show);
}

function escapeHtml(value) {
    return String(value ?? '').replace(/[&<>'"]/g, c => ({
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        "'": '&#39;',
        '"': '&quot;'
    }[c]));
}

function notify(data) {
    const box = $('notifications');
    if (!box) return;
    const el = document.createElement('div');
    el.className = `notification ${data?.type || 'info'}`;
    el.textContent = data?.message || '';
    box.appendChild(el);
    setTimeout(() => el.remove(), data?.duration || 4000);
}

function renderInventory(inv) {
    if (!inv) return;
    state.inventory = inv;
    visible('inventory', true);
    $('inventory-weight').textContent = `${inv.weight || 0} / ${inv.maxWeight || 0}`;
    $('inventory-slots').textContent = `${(inv.items || []).length} / ${inv.maxSlots || 0} slots`;

    const grid = $('inventory-grid');
    grid.innerHTML = '';
    const bySlot = {};
    (inv.items || []).forEach(item => {
        bySlot[item.slot] = item;
    });

    for (let slot = 1; slot <= (inv.maxSlots || 0); slot++) {
        const item = bySlot[slot];
        const el = document.createElement('div');
        el.className = 'slot';
        el.innerHTML = `<span class="number">${slot}</span>${item ? `<span class="amount">${item.amount || 0}</span><span class="name">${escapeHtml(item.label || item.definition?.label || item.item_name || item.name)}</span>` : ''}`;
        if (item) {
            el.addEventListener('dblclick', () => post('inventory:use', { itemName: item.item_name || item.name, slot: item.slot }));
        }
        grid.appendChild(el);
    }
}

function updateMoney(money) {
    if (!money) return;
    $('cash').textContent = `$${money.cash || 0}`;
    $('bank').textContent = `$${money.bank || 0}`;
    $('gold').textContent = money.gold || 0;
}

function updatePlayer(data) {
    const playerData = data?.PlayerData || data;
    if (!playerData) {
        visible('hud', false);
        return;
    }
    visible('hud', true);
    updateMoney(playerData.money);
    $('job').textContent = (playerData.job?.name || 'unemployed').toUpperCase();
}

function beginProgress(data) {
    clearTimeout(state.progressTimer);
    visible('progress', true);
    $('progress-label').textContent = data?.label || 'Working...';
    $('progress-help').textContent = data?.cancellable ? 'Press Backspace to cancel' : '';
    const duration = data?.duration || 3000;
    const fill = $('progress-fill');
    fill.style.transition = 'none';
    fill.style.width = '0';
    requestAnimationFrame(() => requestAnimationFrame(() => {
        fill.style.transition = `width ${duration}ms linear`;
        fill.style.width = '100%';
    }));
    state.progressTimer = setTimeout(() => finishProgress(false), duration);
}

function finishProgress(cancelled) {
    if ($('progress').classList.contains('hidden')) return;
    clearTimeout(state.progressTimer);
    visible('progress', false);
    post('progress:complete', { cancelled });
}

function drawText(data) {
    const el = $('drawtext');
    el.textContent = data?.text || '';
    el.dataset.position = data?.position || 'left';
    el.classList.remove('pressed');
    visible('drawtext', true);
}

window.addEventListener('message', e => {
    const { action, data } = e.data || {};
    if (action === 'theme' && data?.accent) document.documentElement.style.setProperty('--gold', data.accent);
    if (action === 'startup') return;
    if (action === 'player') updatePlayer(data);
    if (action === 'money') updateMoney(data);
    if (action === 'job') $('job').textContent = (data?.name || 'unemployed').toUpperCase();
    if (action === 'notify') notify(data);
    if (action === 'inventory') renderInventory(data);
    if (action === 'inventory:close') visible('inventory', false);
    if (action === 'progress') beginProgress(data);
    if (action === 'progress:cancel') finishProgress(true);
    if (action === 'drawtext') drawText(data);
    if (action === 'drawtext:hide') visible('drawtext', false);
    if (action === 'drawtext:key') $('drawtext').classList.add('pressed');
});

$('close-inventory').addEventListener('click', () => post('inventory:close'));
document.addEventListener('keyup', e => {
    if (e.key === 'Escape' && !$('inventory').classList.contains('hidden')) post('inventory:close');
});
