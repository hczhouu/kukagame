
function generateCToken(data) {
    var raw = data.userId + data.userToken + data.packageName + data.accessKeyId + data.accessChannel;
    var key = CryptoJS.enc.Hex.parse(data.accessKey);
    var aes = CryptoJS.AES.encrypt(raw, key, {
        iv: "",
        mode: CryptoJS.mode.ECB,
        padding: CryptoJS.pad.Pkcs7,
    });
    var aesBytes = aes.ciphertext.toString();
    var inSha1 = CryptoJS.enc.Hex.parse(aesBytes);
    var sha1 = CryptoJS.SHA1(inSha1);
    return sha1.toString();
};

// 初始化SDK
function initSDK(data) {
    Cloudplay.initSDK({
        accessKeyID: data.accessKeyId,
        channelId: data.accessChannel,
        pkg_name: data.packageName,
        onSceneChanged: function (sceneId, extraInfo) {
            
        },
        MessageHandler: function (message) {
            
        }
    })
};

// 启动SDK
function startSDK(data) {
    Cloudplay.startSDK('#example', {
        userinfo: {
            uId: data.userId,
            utoken: data.userToken,
        },
        priority: 0,
        extraId: '',
        pkg_name: data.packageName,
        playingtime: data.remainTime,
        configinfo: 'configinfo',
        // 通过函数获取token
        c_token: this.generateCToken(data),
        rotate: data.rotate,
        isArchive: data.isArchive,
        appChannel: data.appChannel,
        EscLongPress:true,
        // 额外传递参数
        protoData: JSON.stringify(data.protoData)
    })
};

//退出游戏
function exitGame() {
    Cloudplay.stopSDK()
};

