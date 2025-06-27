
function aesDecrypt(ciphertextBase64, keyHex, ivHex) {
    const key = CryptoJS.enc.Utf8.parse(keyHex);
    const iv = CryptoJS.enc.Utf8.parse(ivHex);

    // 将 Base64 编码的密文转换为 WordArray
    const ciphertext = CryptoJS.enc.Base64.parse(ciphertextBase64);
    // 执行 AES 解密
    const decrypted = CryptoJS.AES.decrypt(
        { ciphertext: ciphertext },
        key,
        {
            iv: iv,
            mode: CryptoJS.mode.CBC,
            padding: CryptoJS.pad.Pkcs7
        }
    );

    // 将解密后的 WordArray 转换为字符串
    const plaintext = decrypted.toString(CryptoJS.enc.Utf8);
    return plaintext;
}

document.addEventListener('DOMContentLoaded', () => {
    if (window.electronAPI && window.electronAPI.receiveCppData) {
        window.electronAPI.receiveCppData((data) => {
            if (data === true)
            {
                console.log("exit_game")
                exitGame()
            } else {
                const keyHex = '730o458@#5A>!2.='; // 128位密钥（16字节）
                const ivHex = '0000000000000000';   // 128位IV（16字节）
                const haimacloudData = JSON.parse(aesDecrypt(data[1], keyHex, ivHex));
                initSDK(haimacloudData)
                startSDK(haimacloudData)
            }

        });
    }
});