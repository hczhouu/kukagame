
const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('electronAPI', {
  receiveCppData: (callback) => ipcRenderer.on('cpp-data', (event, data) => callback(data))
});


