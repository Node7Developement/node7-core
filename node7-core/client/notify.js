const notify = (message, type = 'info', duration = 4000) => {
  emit('node7:client:notify', {
    message: String(message ?? ''),
    type: String(type || 'info'),
    duration: Number(duration) || 4000,
  });
};

onNet('node7:client:notifyNative', notify);
exports('ShowNotification', notify);
