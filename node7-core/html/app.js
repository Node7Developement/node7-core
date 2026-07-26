(() => {
    'use strict';

    const container = document.getElementById('notifications');
    const template = document.getElementById('notification-template');
    const active = new Map();
    let nextId = 1;

    const syncNuiVisibility = () => {
        document.documentElement.style.background = 'transparent';
        document.body.style.background = 'transparent';
        document.body.classList.toggle('nui-active', active.size > 0);
    };

    const safeText = (value, fallback = '') => {
        if (value === null || value === undefined) return fallback;
        return String(value);
    };

    const clampDuration = (value) => {
        const parsed = Number(value);
        if (!Number.isFinite(parsed)) return 5000;
        return Math.min(30000, Math.max(1000, Math.floor(parsed)));
    };

    const normalizeType = (value) => {
        const type = safeText(value, 'info').toLowerCase();
        const aliases = {
            inform: 'info', primary: 'info', default: 'info',
            danger: 'error', fail: 'error', failed: 'error',
            warn: 'warning', cash: 'money', bank: 'money'
        };
        const normalized = aliases[type] || type;
        return ['info', 'success', 'error', 'warning', 'money', 'alert'].includes(normalized)
            ? normalized
            : 'info';
    };

    const removeNotification = (id) => {
        const entry = active.get(id);
        if (!entry || entry.leaving) return;
        entry.leaving = true;
        window.clearTimeout(entry.timeout);
        entry.element.classList.remove('is-entering');
        entry.element.classList.add('is-leaving');
        window.setTimeout(() => {
            entry.element.remove();
            active.delete(id);
            syncNuiVisibility();
        }, 340);
    };

    const showNotification = (payload = {}) => {
        const id = safeText(payload.id, `node7-${nextId++}`);
        const type = normalizeType(payload.type);
        const duration = clampDuration(payload.duration);
        const title = safeText(payload.title, type === 'alert' ? 'ALERT!!' : 'NODE7');
        const message = safeText(payload.description ?? payload.message ?? payload.text, '');
        const portrait = safeText(payload.image ?? payload.icon, 'images/default-portrait.png');

        const previous = active.get(id);
        if (previous) {
            window.clearTimeout(previous.timeout);
            previous.element.remove();
            active.delete(id);
        }

        const element = template.content.firstElementChild.cloneNode(true);
        element.dataset.id = id;
        element.dataset.type = type;
        element.querySelector('.notification__title').textContent = title;
        element.querySelector('.notification__message').textContent = message;

        const image = element.querySelector('.notification__portrait');
        image.src = portrait || 'images/default-portrait.png';
        image.addEventListener('error', () => {
            image.src = 'images/default-portrait.png';
        }, { once: true });

        const timer = element.querySelector('.notification__timer');
        timer.style.animation = `node7-timer ${duration}ms linear forwards`;

        container.appendChild(element);
        active.set(id, { element, timeout: null, leaving: false });
        syncNuiVisibility();
        requestAnimationFrame(() => element.classList.add('is-entering'));

        const timeout = window.setTimeout(() => removeNotification(id), duration);
        active.get(id).timeout = timeout;

        if (active.size > 4) {
            const overflow = [...active.keys()].slice(0, active.size - 4);
            overflow.forEach(removeNotification);
        }
    };

    const clearAll = () => {
        for (const id of [...active.keys()]) removeNotification(id);
        if (active.size === 0) syncNuiVisibility();
    };

    syncNuiVisibility();

    const style = document.createElement('style');
    style.textContent = '@keyframes node7-timer { from { transform: scaleX(1); } to { transform: scaleX(0); } }';
    document.head.appendChild(style);

    if (new URLSearchParams(window.location.search).get('preview') === '1') {
        window.setTimeout(() => showNotification({
            id: 'preview',
            type: 'alert',
            title: 'ALERT!!',
            description: 'Your alert was sent! you can use /alertcancel if you dont need help anymore',
            duration: 30000,
            image: 'images/default-portrait.png'
        }), 100);
    }

    window.addEventListener('message', (event) => {
        const data = event.data || {};
        switch (data.action) {
            case 'show':
            case 'notify':
                showNotification(data.notification || data.payload || data);
                break;
            case 'remove':
                removeNotification(safeText(data.id));
                break;
            case 'clear':
                clearAll();
                break;
            default:
                break;
        }
    });
})();
