const resource=typeof GetParentResourceName==='function'?GetParentResourceName():'node7-core';
const $=id=>document.getElementById(id);
const post=(name,data={})=>fetch(`https://${resource}/${name}`,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(data)}).then(r=>r.json());
const state={progressTimer:null};
function visible(id,show){const el=$(id);if(el)el.classList.toggle('hidden',!show)}
function notify(data){const el=document.createElement('div');el.className=`notification ${data.type||'info'}`;el.textContent=data.message;const box=$('notifications');box.appendChild(el);setTimeout(()=>el.remove(),data.duration||4000)}
`;$('bank').textContent=`$${money.bank||0}`;$('gold').textContent=money.gold||0}

function beginProgress(data){clearTimeout(state.progressTimer);visible('progress',true);$('progress-label').textContent=data.label;$('progress-help').textContent=data.cancellable?'Press Backspace to cancel':'';const fill=$('progress-fill');fill.style.transition='none';fill.style.width='0';requestAnimationFrame(()=>requestAnimationFrame(()=>{fill.style.transition=`width ${data.duration}ms linear`;fill.style.width='100%'}));state.progressTimer=setTimeout(()=>finishProgress(false),data.duration)}
function finishProgress(cancelled){if($('progress').classList.contains('hidden'))return;clearTimeout(state.progressTimer);visible('progress',false);post('progress:complete',{cancelled})}
function drawText(data){const el=$('drawtext');el.textContent=data?.text||'';el.dataset.position=data?.position||'left';el.classList.remove('pressed');visible('drawtext',true)}
window.addEventListener('message',e=>{const {action,data}=e.data||{};if(action==='theme'&&data?.accent)document.documentElement.style.setProperty('--gold',data.accent);if(action==='pause')document.body.classList.toggle('pause-hidden',data===true);if(action==='startup')visible('startup',false);if(action==='characters:close')visible('characters',false);if(action==='inventory:close')visible('inventory',false);if(action==='notify')notify(data);if(action==='progress')beginProgress(data);if(action==='progress:cancel')finishProgress(true);if(action==='drawtext')drawText(data);if(action==='drawtext:hide')visible('drawtext',false);if(action==='drawtext:key')$('drawtext').classList.add('pressed')});
