# harbor-1.4+Swagger-auto-install
=========================
Harbor是一款開源的docker registry , 有別於官方簡易的DTR , 有了UI介面方便管理者對Image坐更好的分類管理 <br>
以及進一步的權限控管, 預設的官方Harbor並沒把Swagger加進去 , 有了Swagger後 , 你便更輕易讀懂RESTful API該怎麼打 <br>
腳本上還附加對harbor的兒裝要裝的依賴 ：
1. docker
2. docker-compose
3. python <br>
此腳本是以Ubuntu為基礎OS , 若是其他OS , 對於安裝環境的依賴腳本是不可運行的

腳本設定方式 : 
vi all_install.sh
設定以下變數 : <br>
1.SERVER_IP : 安裝的機器的IP
2.DOCKER_VERSION : 安裝的docker版本 , 建議用預設的

運行安裝
./all_install.sh

安裝限制 : 
有網路環境 , 若無網路環境 , 請先將Harbor所需的image事先pull 到所需機器上
image 清單 : 
vmware/registry-photon      v2.6.2-v1.4.0 
vmware/nginx-photon         v1.4.0
vmware/harbor-log           v1.4.0 
vmware/harbor-jobservice    v1.4.0 
vmware/harbor-ui            v1.4.0
vmware/harbor-adminserver   v1.4.0
vmware/harbor-db            v1.4.0
