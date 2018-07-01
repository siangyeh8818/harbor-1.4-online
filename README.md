# harbor-1.4+Swagger-auto-install
=========================
Harbor是一款開源的docker registry , 有別於官方簡易的DTR , 有了UI介面方便管理者對Image坐更好的分類管理
以及進一步的權限控管, 預設的官方Harbor並沒把Swagger加進去 , 有了Swagger後 , 你便更輕易讀懂RESTful API該怎麼打
腳本上還附加對harbor的兒裝要裝的依賴 ：
1. docker
2. docker-compose
3. python <br>
此腳本是以Ubuntu為基礎OS , 若是其他OS , 對於安裝環境的依賴腳本是不可運行的
