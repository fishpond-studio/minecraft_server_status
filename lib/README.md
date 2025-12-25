# Minecraft Server Status

MinecraftServerStatus 类使用文档

```dart
var server = MinecraftServerStatus(host: '192.168.1.3', port: 25565);
// 实例化类
await server.getServerStatus();
// 调用
// 需要使用 await
```

返回值示例

```json
{
    "version": {
        "name": "1.21.8",
        "protocol": 772
    },
    "players": {
        "max": 20,
        "online": 1,
        "sample": [
            {
                "name": "thinkofdeath",
                "id": "4566e69f-c907-48ee-8d71-d7ba5aa00d20"
            }
        ]
    },
    "description": {
        "text": "Hello, world!"
    },
    "favicon": "data:image/png;base64,<data>",
    "enforcesSecureChat": false
}
```

## 后续计划

- 加入获取服务器延迟的方法
