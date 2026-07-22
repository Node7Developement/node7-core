const resource =
    typeof GetParentResourceName === 'function'
        ? GetParentResourceName()
        : 'node7-core';

const byId = (id) => document.getElementById(id);

const post = (name, data = {}) =>
    fetch(`https://${resource}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    }).then((response) => response.json());

const state = {
    progressTimer: null
};

function visible(id, show) {
    const element = byId(id);
    if (element) {
        element.classList.toggle('hidden', !show);
    }
}

function notify(data = {}) {
    const box = byId('notifications');
    if (!box) return;

    const element = document.createElement('div');
    element.className = `notification ${data.type || 'info'}`;
    element.textContent = String(data.message || '');

    box.appendChild(element);

    setTimeout(() => {
        element.remove();
    }, Number(data.duration) || 4000);
}

function beginProgress(data = {}) {
    const progress = byId('progress');
    const label = byId('progress-label');
    const help = byId('progress-help');
    const fill = byId('progress-fill');

    if (!progress || !label || !help || !fill) return;

    clearTimeout(state.progressTimer);
    visible('progress', true);

    label.textContent = String(data.label || 'Working...');
    help.textContent = data.cancellable ? 'Press Backspace to cancel' : '';

    fill.style.transition = 'none';
    fill.style.width = '0';

    const duration = Math.max(Number(data.duration) || 3000, 250);

    requestAnimationFrame(() => {
        requestAnimationFrame(() => {
            fill.style.transition = `width ${duration}ms linear`;
            fill.style.width = '100%';
        });
    });

    state.progressTimer = setTimeout(() => {
        finishProgress(false);
    }, duration);
}

function finishProgress(cancelled) {
    const progress = byId('progress');
    if (!progress || progress.classList.contains('hidden')) return;

    clearTimeout(state.progressTimer);
    visible('progress', false);

    post('progress:complete', {
        cancelled: cancelled === true
    }).catch(() => {});
}

function drawText(data = {}) {
    const element = byId('drawtext');
    if (!element) return;

    element.textContent = String(data.text || '');
    element.dataset.position = data.position || 'left';
    element.classList.remove('pressed');
    visible('drawtext', true);
}

window.addEventListener('message', (event) => {
    const payload = event.data || {};
    const action = payload.action;
    const data = payload.data;

    if (action === 'theme' && data && data.accent) {
        document.documentElement.style.setProperty('--gold', data.accent);
        return;
    }

    if (action === 'pause') {
        document.body.classList.toggle('pause-hidden', data === true);
        return;
    }

    if (action === 'startup') {
        visible('startup', false);
        return;
    }

    if (action === 'characters:close') {
        visible('characters', false);
        return;
    }

    if (action === 'inventory:close') {
        visible('inventory', false);
        return;
    }

    // HUD messages are deliberately ignored. Core no longer owns a HUD.
    if (
        action === 'player' ||
        action === 'money' ||
        action === 'job' ||
        action === 'gang' ||
        action === 'status'
    ) {
        return;
    }

    if (action === 'notify') {
        notify(data);
        return;
    }

    if (action === 'progress') {
        beginProgress(data);
        return;
    }

    if (action === 'progress:cancel') {
        finishProgress(true);
        return;
    }

    if (action === 'drawtext') {
        drawText(data);
        return;
    }

    if (action === 'drawtext:hide') {
        visible('drawtext', false);
        return;
    }

    if (action === 'drawtext:key') {
        const element = byId('drawtext');
        if (element) {
            element.classList.add('pressed');
        }
    }
});
