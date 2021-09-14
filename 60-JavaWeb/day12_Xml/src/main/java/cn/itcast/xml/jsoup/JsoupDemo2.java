package cn.itcast.xml.jsoup;


import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.IOException;
import java.net.URL;

/**
 * Jsoup对象功能
 */
public class JsoupDemo2 {
    public static void main(String[] args) throws IOException {
        //2.1获取student.xml的path
        String path = JsoupDemo2.class.getClassLoader().getResource("student.xml").getPath();
        //2.2解析xml文档，加载文档进内存，获取dom树--->Document
//        Document document = Jsoup.parse(new File(path), "utf-8");
//        System.out.println(document);


       //2.parse​(String html)：解析xml或html字符串
       /*
       String str = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n" +
                "\n" +
                "<students>\n" +
                "\t<student number=\"heima_0001\">\n" +
                "\t\t<name>tom</name>\n" +
                "\t\t<age>18</age>\n" +
                "\t\t<sex>male</sex>\n" +
                "\t</student>\n" +
                "\t<student number=\"heima_0002\">\n" +
                "\t\t<name>jack</name>\n" +
                "\t\t<age>18</age>\n" +
                "\t\t<sex>female</sex>\n" +
                "\t</student>\n" +
                "\n" +
                "</students>";
        Document document = Jsoup.parse(str);
        System.out.println(document);
        */

       //3.parse​(URL url, int timeoutMillis)：通过网络路径获取指定的html或xml的文档对象
        URL url = new URL("https://baike.baidu.com/item/jsoup/9012509?fr=aladdin");//代表网络中的一个资源路径
        Document document = Jsoup.parse(url, 10000);
        System.out.println(document);
    }

}
// 输出:
//<!--STATUS OK-->
//<!doctype html>
//<html>
//<head>
//<meta charset="UTF-8">
//<meta http-equiv="X-UA-Compatible" content="IE=Edge">
//<meta name="referrer" content="always">
//<meta name="description" content="jsoup 是一款Java 的HTML解析器，可直接解析某个URL地址、HTML文本内容。它提供了一套非常省力的API，可通过DOM，CSS以及类似于jQuery的操作方法来取出和操作数据。">
//<title>jsoup_百度百科</title>
//<link rel="shortcut icon" href="/favicon.ico" type="image/x-icon">
//<link rel="icon" sizes="any" mask href="http://baikebcs.bdimg.com/cms/static/baike-icon.svg">
//<meta name="csrf-token" content="">
//<meta itemprop="dateUpdate" content="2021-05-06 08:34:42">
//<meta name="keywords" content="jsoup, jsoup内容简介, jsoup主要功能, jsoup总结">
//<link rel="alternate" hreflang="x-default" href="https://baike.baidu.com/item/jsoup/9012509">
//<link rel="alternate" hreflang="zh" href="https://baike.baidu.com/item/jsoup/9012509">
//<link rel="alternate" hreflang="zh-Hans" href="https://baike.baidu.com/item/jsoup/9012509">
//<link rel="alternate" hreflang="zh-Hant" href="https://baike.baidu.hk/item/jsoup/9012509">
//<link rel="canonical" href="https://baike.baidu.com/item/jsoup/9012509">
//<meta name="image" content="https://bkimg.cdn.bcebos.com/smart/1e30e924b899a9011fcfd12f16950a7b0208f535-bkimg-process,v_1,rw_1,rh_1,pad_1,color_ffffff?x-bce-process=image/format,f_auto">
//<meta property="og:title" content="jsoup_百度百科">
//<meta property="og:description" content="jsoup 是一款Java 的HTML解析器，可直接解析某个URL地址、HTML文本内容。它提供了一套非常省力的API，可通过DOM，CSS以及类似于jQuery的操作方法来取出和操作数据。">
//<meta property="og:image" content="https://bkimg.cdn.bcebos.com/smart/1e30e924b899a9011fcfd12f16950a7b0208f535-bkimg-process,v_1,rw_1,rh_1,pad_1,color_ffffff?x-bce-process=image/format,f_auto">
//<meta property="og:url" content="https://baike.baidu.com/item/jsoup/9012509?fr=aladdin">
//<meta property="og:site_name" content="百度百科">
//<meta property="og:type" content="website">
//<style>
//        . {
//                display: none !important;
//                }
//</style>
//<!--[if lte IE 9]>
//<script>
//    (function() {
//            var e = "abbr,article,aside,audio,canvas,datalist,details,dialog,eventsource,figure,footer,header,hgroup,mark,menu,meter,nav,output,progress,section,time,video".split(","),
//            i = e.length;
//            while (i--) {
//            document.createElement(e[i]);
//            }
//
//            window.console = window.console || {};
//            var f = ['log', 'info', 'warning', 'error', 'clear'];
//            var l = f.length;
//            while(l--) {
//            window.console[f[l]] = function () {};
//            }
//            })();
//</script>
//<![endif]-->
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/pkg/wiki-lemma_bb7224b.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-common/pkg/wiki-common-base_e67c67b.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-common/widget/component/userbar-n/userbar-n_2fb1463.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-common/widget/lib/larkplayer/larkplayer_e3da335.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-common/widget/lib/webuploader/webuploader_08d9db4.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/announcement/announcement_cba33f4.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/label/label_1b0bc0e.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/newSideShare/sideShare_7e089b7.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/video/pageMask/pageMask_ff9a193.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/pkg/wiki-lemma-module_27edf15.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/mainContent_47f1933.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/lemmaRelation/lemmaRelation_496a30a.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/zhixin/zhixin_3b0d7a5.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/searchHeader/toolButtons-n/toolButtons-n_4a39b13.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/searchHeader/toolButtons-n/userInfo-n_7e90184.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/searchHeader/searchHeader-n_f9a6e5b.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/widget/feature/Audio/audio_82f2561.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/widget/feature/generalAdvert/advertActivity/advertActivity_f3e768c.css">
//<link rel="stylesheet" type="text/css" href="https://bkssl.bdimg.com/static/wiki-lemma/widget/feature/generalAdvert/advertBaseInfo/advertBaseInfo_32e601e.css">
//<script>
//        var _hmt = _hmt || [];
//                (function() {
//                var hm = document.createElement("script");
//                hm.src = "https://hm.baidu.com/hm.js?55b574651fcae74b0a9f1cf9c8d7c93a";
//                var s = document.getElementsByTagName("script")[0];
//                s.parentNode.insertBefore(hm, s);
//                })();
//</script>
//</head>
//<body class="wiki-lemma neweditor normal">
//<div class="header-wrapper pc-header-new">
//<div style="display:none;" id="J-vars" data-lemmaid="9012509" data-lemmatitle="jsoup"></div>
//<div class="topbar cmn-clearfix">
//<ul class="wgt-userbar wgt-userbar-n" id="j-wgt-userbar">
//<li> <a href="http://www.baidu.com/">百度首页</a> </li>
//</ul>
//<div class="separator"></div>
//<div class="wiki-common-headTabBar">
//<a href="https://www.baidu.com/" nslog="normal" nslog-type="10600112" data-href="https://www.baidu.com/s?ie=utf-8&amp;fr=bks0000&amp;wd=">网页</a>
//<a href="http://news.baidu.com/" nslog="normal" nslog-type="10600112" data-href="http://news.baidu.com/ns?tn=news&amp;cl=2&amp;rn=20&amp;ct=1&amp;fr=bks0000&amp;ie=utf-8&amp;word=">新闻</a>
//<a href="https://tieba.baidu.com/" nslog="normal" nslog-type="10600112" data-href="https://tieba.baidu.com/f?ie=utf-8&amp;fr=bks0000&amp;kw=">贴吧</a>
//<a href="https://zhidao.baidu.com/" nslog="normal" nslog-type="10600112" data-href="https://zhidao.baidu.com/search?pn=0&amp;&amp;rn=10&amp;lm=0&amp;fr=bks0000&amp;word=">知道</a>
//<a href="http://music.baidu.com/" nslog="normal" nslog-type="10600112" data-href="http://music.baidu.com/search?f=ms&amp;ct=134217728&amp;ie=utf-8&amp;rn=&amp;lm=-1&amp;pn=30&amp;fr=bks0000&amp;key=">音乐</a>
//<a href="http://image.baidu.com/" nslog="normal" nslog-type="10600112" data-href="http://image.baidu.com/search/index?tn=baiduimage&amp;ct=201326592&amp;lm=-1&amp;cl=2&amp;nc=1&amp;ie=utf-8&amp;word=">图片</a>
//<a href="http://v.baidu.com/" nslog="normal" nslog-type="10600112" data-href="https://www.baidu.com/sf/vsearch?pd=video&amp;tn=vsearch&amp;ie=utf-8&amp;rsv_spt=17&amp;wd=">视频</a>
//<a href="http://map.baidu.com/" nslog="normal" nslog-type="10600112" data-href="http://map.baidu.com/m?ie=utf-8&amp;fr=bks0000&amp;word=">地图</a>
//<a href="https://wenku.baidu.com/" nslog="normal" nslog-type="10600112" data-href="https://wenku.baidu.com/search?lm=0&amp;od=0&amp;ie=utf-8&amp;fr=bks0000&amp;word=">文库</a>
//<b class="baike">百科</b>
//</div>
//</div>
//<div class="header">
//<div class="layout">
//<div class="wgt-searchbar wgt-searchbar-new wgt-searchbar-main cmn-clearfix wgt-searchbar-large">
//<div class="logo-container">
//<a class="logo cmn-inline-block" title="到百科首页" href="/"> <span class="cmn-baike-logo"> <em class="cmn-icon cmn-icons cmn-icons_logo-bai"></em> <em class="cmn-icon cmn-icons cmn-icons_logo-du"></em> <em class="cmn-icon cmn-icons cmn-icons_logo-baike"></em> </span> </a>
//</div>
//<div class="search">
//<div class="form">
//<form id="searchForm" action="/search/word" method="GET" target="_self">
//<input id="query" nslog="normal" nslog-type="10080011" name="word" type="text" autocomplete="off" autocorrect="off" value="jsoup">
//<button id="search" nslog="normal" nslog-type="10080008" type="button">进入词条</button>
//<button id="searchLemma" nslog="normal" nslog-type="10080009" type="button">全站搜索</button>
//<a class="help" href="/help" nslog="normal" nslog-type="10080010" target="_blank">帮助</a>
//</form>
//<form id="searchLemmaForm" action="/search" method="GET" target="_self">
//<input id="searchLemmaQuery" name="word" type="hidden">
//<input name="pn" type="hidden" value="0">
//<input name="rn" type="hidden" value="0">
//<input name="enc" type="hidden" value="utf8">
//</form>
//<ul id="suggestion" class="suggestion">
//<div class="sug"></div>
//<li class="extra"> <span id="clear" style="margin-right:8px;">清除历史记录</span><span id="close" nslog="normal" nslog-type="10080012">关闭</span> </li>
//</ul>
//</div>
//</div>
//</div>
//<div class="declare-wrap" id="J-declare-wrap">
//<div class="declare" id="J-declare">
//        声明：百科词条人人可编辑，词条创建和修改均免费，绝不存在官方及代理商付费代编，请勿上当受骗。
//<a class="declare-details" target="_blank" href="/common/declaration">详情&gt;&gt;</a>
//<div class="close-btn" id="J-declare-close">
//<em class="cmn-icon cmn-icons cmn-icons_close"></em>
//</div>
//</div>
//</div>
//</div>
//</div>
//</div>
//<div class="navbar-wrapper">
//<div class="wgt-navbar">
//<div class="navbar-bg">
//<div class="navbar-bg-top">
//<div class="navbar-content layout">
//<div class="navbar-content-box">
//<dl class="index ">
//<dt>
//<a href="/">首页</a>
//</dt>
//<dd>
//<div>
//<a href="/calendar/" target="_blank">历史上的今天</a>
//</div>
//<div>
//<a href="/vbaike/" target="_blank">百科冷知识</a>
//</div>
//<div>
//<a href="/vbaike#gallary" target="_blank">图解百科</a>
//</div>
//</dd>
//</dl>
//<dl class="second-know ">
//<dt>
//          秒懂百科
//</dt>
//<dd>
//<div>
//<a href="https://child.baidu.com/" target="_blank">懂啦</a>
//</div>
//<div>
//<a href="/item/秒懂本尊答" target="_blank">秒懂本尊答</a>
//</div>
//<div>
//<a href="/item/秒懂大师说" target="_blank">秒懂大师说</a>
//</div>
//<div>
//<a href="/item/秒懂看瓦特" target="_blank">秒懂看瓦特</a>
//</div>
//<div>
//<a href="/item/秒懂五千年" target="_blank">秒懂五千年</a>
//</div>
//<div>
//<a href="/item/秒懂全视界" target="_blank">秒懂全视界</a>
//</div>
//</dd>
//</dl>
//<dl class="special ">
//<dt>
//          特色百科
//</dt>
//<dd>
//<div>
//<a href="/museum" target="_blank">数字博物馆</a>
//</div>
//<div>
//<a href="/feiyi?fr=dhlfeiyi" target="_blank">非遗百科</a>
//</div>
//<div>
//<a href="/wikicategory/view?categoryName=恐龙大全" target="_blank">恐龙百科</a>
//</div>
//<div>
//<a href="/wikicategory/view?categoryName=多肉植物" target="_blank">多肉百科</a>
//</div>
//<div>
//<a href="/art" target="_blank">艺术百科</a>
//</div>
//<div>
//<a href="/science" target="_blank">科学百科</a>
//</div>
//</dd>
//</dl>
//<dl class="user ">
//<dt>
//          用户
//</dt>
//<dd>
//<div>
//<a href="/kedou/" target="_blank">蝌蚪团</a>
//</div>
//<div>
//<a href="/item/百科热词团队" target="_blank">热词团</a>
//</div>
//<div>
//<a href="/campus" target="_blank">百科校园</a>
//</div>
//<div>
//<a href="https://baike.baidu.com/talent/home/index" target="_blank">分类达人</a>
//</div>
//<div>
//<a href="/task/" target="_blank">百科任务</a>
//</div>
//<div>
//<a href="/mall/" target="_blank">百科商城</a>
//</div>
//</dd>
//</dl>
//<dl class="knowledge">
//<dt>
//          知识专题
//</dt>
//<dd id="J-knowledge-content">
//</dd>
//</dl>
//<dl class="cooperation ">
//<dt>
//          权威合作
//</dt>
//<dd>
//<div>
//<a href="/operation/cooperation#joint" target="_blank">合作模式</a>
//</div>
//<div>
//<a href="/operation/cooperation#issue" target="_blank">常见问题</a>
//</div>
//<div>
//<a href="/operation/cooperation#connection" target="_blank">联系方式</a>
//</div>
//</dd>
//</dl>
//<div class="right-list">
//<span class="item appdownload" nslog-type="21040001"><a href="/wapui/subpage/baikeappdownload?sfrom=pc_lemmapage_navigation" target="_blank"><em class="cmn-icon cmn-icons cmn-icons_mobile-phone"></em>下载百科APP</a></span>
//<span class="item usercenter"><a href="/usercenter" target="_blank"><em class="cmn-icon cmn-icons cmn-icons_navbar-usercenter"></em>个人中心</a></span>
//</div>
//</div>
//</div>
//</div>
//</div>
//</div>
//</div>
//<div class="body-wrapper">
//<div class="before-content">
//</div>
//<div class="content-wrapper">
//<div class="content">
//<div class="main-content J-content">
//<div class="top-tool ">
//<a class="add-sub-icon top-tool-icon" href="javascript:;" title="添加义项" nslog-type="50000101"> <em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_add-subLemma-solid"></em> </a>
//<a href="/divideload/jsoup" title="拆分词条" target="_blank" class="split-icon top-tool-icon" style="display:none;" nslog-type="50000104"> <em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_lemma-split"></em> </a>
//<div class="top-collect top-tool-icon" nslog="area" nslog-type="50000102">
//<em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_star-solid"></em>
//<span class="collect-text">收藏</span>
//<div class="collect-tip">
//        查看
//<a href="/uc/favolemma" target="_blank">我的收藏</a>
//</div>
//</div>
//<a href="javascript:void(0);" id="j-top-vote" class="top-vote top-tool-icon" nslog-type="10060801"> <em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_zan-solid"></em> <span class="vote-count">0</span> <span class="vote-tip">有用+1</span> <span class="voted-tip">已投票</span> </a>
//<div class="bksharebuttonbox top-share">
//<a class="top-share-icon top-tool-icon" nslog-type="9067"> <em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_share"></em> <span class="share-count" id="j-topShareCount">0</span> </a>
//<div class="new-top-share" id="top-share">
//<ul class="top-share-list">
//<li class="top-share-item"> <a class="share-link bds_qzone" href="javascript:void(0);" nslog-type="10060501"> <em class="cmn-icon cmn-icons cmn-icons_logo-qzone"></em> </a> </li>
//<li class="top-share-item"> <a class="share-link bds_tsina" href="javascript:void(0);" nslog-type="10060701"> <em class="cmn-icon cmn-icons cmn-icons_logo-sina-weibo"></em> </a> </li>
//<li class="top-share-item"> <a class="bds_wechat" href="javascript:void(0);" nslog-type="10060401"> <em class="cmn-icon cmn-icons cmn-icons_logo-wechat"></em> </a> </li>
//<li class="top-share-item"> <a class="share-link bds_tqq" href="javascript:void(0);" nslog-type="10060601"> <em class="cmn-icon cmn-icons cmn-icons_logo-qq"></em> </a> </li>
//</ul>
//</div>
//</div>
//</div>
//<div style="width:0;height:0;clear:both"></div>
//<dl class="lemmaWgt-lemmaTitle lemmaWgt-lemmaTitle-">
//<dd class="lemmaWgt-lemmaTitle-title J-lemma-title">
//<h1>jsoup</h1>
//<a class="cmn-btn-28 cmn-btn-hover-blue audio-play title-audio-play J-title-audio-play" href="javascript:;"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_audio"></em><span class="J-audio-text">语音</span></a>
//<a href="javascript:;" class="edit-lemma cmn-btn-hover-blue cmn-btn-28 j-edit-link"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_edit-lemma"></em>编辑</a>
//<a class="lock-lemma" nslog-type="10003105" target="_self" href="javascript:;" title="锁定"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_lock-lemma"></em>锁定</a>
//<a href="/planet/talk?lemmaId=9012509" target="_blank" class="lemma-discussion cmn-btn-hover-blue cmn-btn-28 j-discussion-link" nslog-type="90000102"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_discussion-solid"></em>讨论<span class="num"></span></a>
//<a href="javascript:;" class="add-video cmn-btn-hover-blue cmn-btn-28 J-add-video-link J-add-video"> <em class="cmn-icon wiki-lemma-icons add-video-icon wiki-lemma-icons_add-video"></em>上传视频</a>
//<a href="javascript:;" class="cannot-add-video cmn-btn-hover-blue cmn-btn-28 J-add-video-dialog J-cannot-add-video"> <em class="cmn-icon wiki-lemma-icons cannot-add-video-icon wiki-lemma-icons_add-video"></em>上传视频</a>
//</dd>
//</dl>
//<div class="promotion-declaration">
//</div>
//<div class="lemma-summary" label-module="lemmaSummary">
//        <div class="para" label-module="para">
//        jsoup 是一款Java 的HTML解析器，可直接解析某个URL地址、HTML文本内容。它提供了一套非常省力的API，可通过DOM，CSS以及类似于jQuery的操作方法来取出和操作数据。
//        </div>
//        </div>
//        <div class="lemmaWgt-promotion-leadPVBtn">
//        </div>
//        <div class="configModuleBanner">
//        </div>
//        <div class="basic-info J-basic-info cmn-clearfix">
//        <dl class="basicInfo-block basicInfo-left">
//        <dt class="basicInfo-item name">
//        中文名
//        </dt>
//        <dd class="basicInfo-item value">
//        jsoup
//        </dd>
//        <dt class="basicInfo-item name">
//        外文名
//        </dt>
//        <dd class="basicInfo-item value">
//        jsoup
//        </dd>
//        </dl>
//        <dl class="basicInfo-block basicInfo-right">
//        <dt class="basicInfo-item name">
//        类&nbsp;&nbsp;&nbsp;&nbsp;别
//        </dt>
//        <dd class="basicInfo-item value">
//        HTML解析器
//        </dd>
//        <dt class="basicInfo-item name">
//        编写语言
//        </dt>
//        <dd class="basicInfo-item value">
//        Java
//        </dd>
//        <dt class="basicInfo-item name">
//        特&nbsp;&nbsp;&nbsp;&nbsp;点
//        </dt>
//        <dd class="basicInfo-item value">
//        提供了一套非常省力的API
//        </dd>
//        </dl>
//        </div>
//        <div class="lemmaWgt-lemmaCatalog">
//        <div class="lemma-catalog">
//        <h2 class="block-title">目录</h2>
//        <div class="catalog-list column-1">
//        <ol>
//        <li class="level1"> <span class="index">1</span> <span class="text"><a href="#1">内容简介</a></span> </li>
//        <li class="level1"> <span class="index">2</span> <span class="text"><a href="#2">主要功能</a></span> </li>
//        <li class="level1"> <span class="index">3</span> <span class="text"><a href="#3">总结</a></span> </li>
//        </ol>
//        </div>
//        </div>
//        </div>
//        <div class="anchor-list ">
//        <a name="1" class="lemma-anchor para-title"></a>
//        <a name="sub4066913_1" class="lemma-anchor "></a>
//        <a name="内容简介" class="lemma-anchor "></a>
//        </div>
//        <div class="para-title level-2  J-chapter" data-index="1" label-module="para-title">
//        <h2 class="title-text"><span class="title-prefix">jsoup</span>内容简介</h2>
//        <a class="edit-icon j-edit-link" data-edit-dl="1" href="javascript:;"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_edit-lemma"></em>编辑</a>
//        <a class="audio-play part-audio-play J-part-audio-play" href="javascript:;"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_audio"></em> <span class="J-part-audio-text">语音</span> </a>
//        </div>
//        <div class="para" label-module="para">
//        jsoup 是一款Java 的HTML解析器，可直接解析某个URL地址、HTML文本内容。它提供了一套非常省力的API，可通过DOM，CSS以及类似于jQuery的操作方法来取出和操作数据。
//        </div>
//        <div class="anchor-list ">
//        <a name="2" class="lemma-anchor para-title"></a>
//        <a name="sub4066913_2" class="lemma-anchor "></a>
//        <a name="主要功能" class="lemma-anchor "></a>
//        </div>
//        <div class="para-title level-2  J-chapter" data-index="2" label-module="para-title">
//        <h2 class="title-text"><span class="title-prefix">jsoup</span>主要功能</h2>
//        <a class="edit-icon j-edit-link" data-edit-dl="2" href="javascript:;"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_edit-lemma"></em>编辑</a>
//        <a class="audio-play part-audio-play J-part-audio-play" href="javascript:;"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_audio"></em> <span class="J-part-audio-text">语音</span> </a>
//        </div>
//        <div class="para" label-module="para">
//        1. 从一个URL，文件或字符串中解析HTML；
//        </div>
//        <div class="para" label-module="para">
//        2. 使用DOM或CSS选择器来查找、取出数据；
//        </div>
//        <div class="para" label-module="para">
//        3. 可操作
//        <a target="_blank" href="/item/HTML%E5%85%83%E7%B4%A0/5983313" data-lemmaid="5983313">HTML元素</a>、属性、文本；
//        </div>
//        <div class="para" label-module="para">
//        jsoup是基于MIT协议发布的，可放心使用于商业项目。
//        </div>
//        <div class="para" label-module="para">
//        jsoup 的主要类层次结构如下所示：
//        </div>
//        <div class="para" label-module="para">
//        <div class="lemma-picture J-lemma-picture text-pic layout-center" style="width:473px; float: none; display: block; margin: 0px auto; clear: both;">
//        <a class="image-link" nslog-type="9317" href="/pic/jsoup/9012509/0/6a600c338744ebf814706c9ed9f9d72a6059a709?fr=lemma&amp;ct=single" target="_blank" title="" style="width:473px;height:205px;"> <img class="lazy-img" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAMAAAAoyzS7AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAAZQTFRF9fX1AAAA0VQI3QAAAAxJREFUeNpiYAAIMAAAAgABT21Z4QAAAABJRU5ErkJggg==" data-src="https://bkimg.cdn.bcebos.com/pic/6a600c338744ebf814706c9ed9f9d72a6059a709?x-bce-process=image/resize,m_lfit,w_946,limit_1/format,f_auto" alt="" style="width:473px;height:205px;"> </a>
//        </div>
//        </div>
//        <div class="para" label-module="para">
//        接下来我们专门针对几种常见的应用场景举例说明jsoup 是如何优雅的进行HTML 文档处理的。
//        </div>
//        <div class="para" label-module="para">
//        <b>文档输入</b>
//        </div>
//        <div class="para" label-module="para">
//        jsoup 可以从包括字符串、URL地址以及本地文件来加载HTML 文档，并生成Document 对象实例。
//        </div>
//        <div class="para" label-module="para">
//        下面是相关代码：
//        </div>
//        <div class="para" label-module="para">
//        // 直接从字符串中输入HTML 文档
//        </div>
//        <div class="para" label-module="para">
//        String html = "开源中国社区"
//        </div>
//        <div class="para" label-module="para">
//        +"
//        </div>
//        <div class="para" label-module="para">
//        这里是jsoup 项目的相关文章";
//        </div>
//        <div class="para" label-module="para">
//        Document doc = Jsoup.parse(html);
//        </div>
//        <div class="para" label-module="para">
//        // 从URL直接加载HTML 文档
//        </div>
//        <div class="para" label-module="para">
//        Document doc =Jsoup.connect("网址/").get();
//        </div>
//        <div class="para" label-module="para">
//        String title = doc.title();
//        </div>
//        <div class="para" label-module="para">
//        Document doc =Jsoup.connect("网址/")
//        </div>
//        <div class="para" label-module="para">
//        .data("query", "Java") //请求参数
//        </div>
//        <div class="para" label-module="para">
//        .userAgent("I’mjsoup") //设置User-Agent
//        </div>
//        <div class="para" label-module="para">
//        .cookie("auth", "token") //设置cookie
//        </div>
//        <div class="para" label-module="para">
//        .timeout(3000) //设置连接超时时间
//        </div>
//        <div class="para" label-module="para">
//        .post(); //使用POST方法访问URL
//        </div>
//        <div class="para" label-module="para">
//        // 从文件中加载HTML 文档
//        </div>
//        <div class="para" label-module="para">
//        File input = new File("D:/test.html");
//        </div>
//        <div class="para" label-module="para">
//        Document doc = Jsoup.parse(input,"UTF-8","网址/");
//        </div>
//        <div class="para" label-module="para">
//        请大家注意最后一种HTML 文档输入方式中的parse 的第三个参数，为什么需要在这里指定一个网址呢（虽然可以不指定，如第一种方法）？因为HTML 文档中会有很多例如链接、图片以及所引用的外部脚本、css文件等，而第三个名为baseURL 的参数的意思就是当HTML 文档使用
//        <a target="_blank" href="/item/%E7%9B%B8%E5%AF%B9%E8%B7%AF%E5%BE%84">相对路径</a>方式引用外部文件时，jsoup会自动为这些URL 加上一个前缀，也就是这个baseURL。
//        </div>
//        <div class="para" label-module="para">
//        例如开源软件 会被转换成开源软件。
//        </div>
//        <div class="para" label-module="para">
//        <b>解析并提取HTML 元素</b>
//        </div>
//        <div class="para" label-module="para">
//        这部分涉及一个HTML 解析器最基本的功能，但jsoup使用一种有别于其他开源项目的方式——选择器，我们将在最后一部分详细介绍jsoup选择器，本节中你将看到jsoup是如何用最简单的代码实现。
//        </div>
//        <div class="para" label-module="para">
//        不过jsoup也提供了传统的DOM 方式的元素解析，看看下面的代码：
//        </div>
//        <div class="para" label-module="para">
//        File input = new File("D:/test.html");
//        </div>
//        <div class="para" label-module="para">
//        Document doc = Jsoup.parse(input, "UTF-8","网址/");
//        </div>
//        <div class="para" label-module="para">
//        Element content =doc.getElementById("content");
//        </div>
//        <div class="para" label-module="para">
//        Elements links = content.getElementsByTag("a");
//        </div>
//        <div class="para" label-module="para">
//        for (Element link : links) {
//        </div>
//        <div class="para" label-module="para">
//        String linkHref =link.attr("href");
//        </div>
//        <div class="para" label-module="para">
//        String linkText =link.text();
//        </div>
//        <div class="para" label-module="para">
//        }
//        </div>
//        <div class="para" label-module="para">
//        你可能会觉得jsoup的方法似曾相识，没错，像
//        <a target="_blank" href="/item/getElementById">getElementById</a> 和getElementsByTag 方法跟JavaScript 的方法名称是一样的，功能也完全一致。你可以根据节点名称或者是HTML 元素的id 来获取对应的元素或者元素列表。
//        </div>
//        <div class="para" label-module="para">
//        与htmlparser 项目不同的是，jsoup 并没有为HTML 元素定义一个对应的类，一般一个HTML 元素的组成部分包括：节点名、属性和文本，jsoup 提供简单的方法供你自己检索这些数据，这也是jsoup保持瘦身的原因。
//        </div>
//        <div class="para" label-module="para">
//        而在元素检索方面，jsoup 的选择器简直无所不能，
//        </div>
//        <div class="para" label-module="para">
//        File input = new File("D:\test.html");
//        </div>
//        <div class="para" label-module="para">
//        Document doc =Jsoup.parse(input,"UTF-8","网址");
//        </div>
//        <div class="para" label-module="para">
//        Elements links = doc.select("a[href]"); // 具有href 属性的链接
//        </div>
//        <div class="para" label-module="para">
//        Elements pngs = doc.select("img[src$=.png]");//所有引用png图片的元素
//        </div>
//        <div class="para" label-module="para">
//        Element masthead =doc.select("div.masthead").first();
//        </div>
//        <div class="para" label-module="para">
//        // 找出定义了class=masthead 的元素
//        </div>
//        <div class="para" label-module="para">
//        Elements resultLinks = doc.select("h3.r &gt;a"); // direct a after h3
//        </div>
//        <div class="para" label-module="para">
//        jsoup使用跟jQuery 一模一样的选择器对元素进行检索，以上的检索方法如果换成是其他的HTML 解释器，至少都需要很多行代码，而jsoup 只需要一行代码即可完成。
//        </div>
//        <div class="para" label-module="para">
//        jsoup 的选择器还支持
//        <a target="_blank" href="/item/%E8%A1%A8%E8%BE%BE%E5%BC%8F">表达式</a>功能，我们将在最后一节介绍这个超强的选择器。
//        </div>
//        <div class="para" label-module="para">
//        <b>修改数据</b>
//        </div>
//        <div class="para" label-module="para">
//        在解析文档的同时，我们可能会需要对文档中的某些元素进行修改，例如我们可以为文档中的所有图片增加可点击链接、修改链接地址或者是修改文本等。
//        </div>
//        <div class="para" label-module="para">
//        下面是一些简单的例子：
//        </div>
//        <div class="para" label-module="para">
//        doc.select("div.commentsa").attr("rel", "nofollow");
//        </div>
//        <div class="para" label-module="para">
//        //为所有链接增加rel=nofollow 属性
//        </div>
//        <div class="para" label-module="para">
//        doc.select("div.commentsa").addClass("mylinkclass");
//        </div>
//        <div class="para" label-module="para">
//        //为所有链接增加class=mylinkclass 属性
//        </div>
//        <div class="para" label-module="para">
//        doc.select("img").removeAttr("onclick");//删除所有图片的onclick属性
//        </div>
//        <div class="para" label-module="para">
//        doc.select("input[type=text]").val("");//清空所有文本输入框中的文本
//        </div>
//        <div class="para" label-module="para">
//        道理很简单，你只需要利用jsoup 的选择器找出元素，然后就可以通过以上的方法来进行修改，除了无法修改标签名外（可以删除后再插入新的元素），包括元素的属性和文本都可以修改。
//        </div>
//        <div class="para" label-module="para">
//        修改完直接调用Element(s) 的html() 方法就可以获取修改完的HTML 文档。
//        </div>
//        <div class="para" label-module="para">
//        <b>HTML 文档清理</b>
//        </div>
//        <div class="para" label-module="para">
//        jsoup 在提供强大的API 同时，人性化方面也做得非常好。在做网站的时候，经常会提供用户评论的功能。有些用户比较淘气，会搞一些脚本到评论内容中，而这些脚本可能会破坏整个页面的行为，更严重的是获取一些机要信息，例如XSS 跨站点攻击之类的。
//        </div>
//        <div class="para" label-module="para">
//        jsoup 对这方面的支持非常强大，使用非常简单。看看下面这段代码：
//        </div>
//        <div class="para" label-module="para">
//        String unsafe = "
//        </div>
//        <div class="para" label-module="para">
//        开源中国社区";
//        </div>
//        <div class="para" label-module="para">
//        String safe = Jsoup.clean(unsafe, Whitelist.basic());
//        </div>
//        <div class="para" label-module="para">
//        // 输出:
//        </div>
//        <div class="para" label-module="para">
//        //
//        </div>
//        <div class="para" label-module="para">
//        开源中国社区
//        </div>
//        <div class="para" label-module="para">
//        jsoup 使用一个Whitelist 类用来对HTML 文档进行过滤，该类提供几个常用方法：
//        </div>
//        <div class="para" label-module="para">
//        <div class="lemma-picture J-lemma-picture text-pic layout-center" style="width:640px; float: none; display: block; margin: 0px auto; clear: both;">
//        <a class="image-link" nslog-type="9317" href="/pic/jsoup/9012509/0/730e0cf3d7ca7bcb0fe1cf8ebe096b63f724a8fc?fr=lemma&amp;ct=single" target="_blank" title="" style="width:640px;height:279.3423019432px;"> <img class="lazy-img" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAMAAAAoyzS7AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAAZQTFRF9fX1AAAA0VQI3QAAAAxJREFUeNpiYAAIMAAAAgABT21Z4QAAAABJRU5ErkJggg==" data-src="https://bkimg.cdn.bcebos.com/pic/730e0cf3d7ca7bcb0fe1cf8ebe096b63f724a8fc?x-bce-process=image/resize,m_lfit,w_1280,limit_1/format,f_auto" alt="" style="width:640px;height:279.3423019432px;"> </a>
//        </div>
//        </div>
//        <div class="para" label-module="para">
//        如果这五个过滤器都无法满足你的要求呢，例如你允许用户插入flash 动画，没关系，Whitelist提供扩展功能，例如whitelist.addTags("embed","object","param","span","div");也可调用addAttributes 为某些元素增加属性。
//        </div>
//        <div class="para" label-module="para">
//        <b>jsoup 的过人之处——选择器</b>
//        </div>
//        <div class="para" label-module="para">
//        前面我们已经简单的介绍了jsoup是如何使用选择器来对元素进行检索的。本节我们把重点放在选择器本身强大的语法上。下表是jsoup选择器的所有语法详细列表。
//        </div>
//        <div class="para" label-module="para">
//        基本用法
//        </div>
//        <div class="para" label-module="para">
//        <div class="lemma-picture J-lemma-picture text-pic layout-center" style="width:640px; float: none; display: block; margin: 0px auto; clear: both;">
//        <a class="image-link" nslog-type="9317" href="/pic/jsoup/9012509/0/6609c93d70cf3bc71c68c54dd100baa1cd112a22?fr=lemma&amp;ct=single" target="_blank" title="" style="width:640px;height:387.41839762611px;"> <img class="lazy-img" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAMAAAAoyzS7AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAAZQTFRF9fX1AAAA0VQI3QAAAAxJREFUeNpiYAAIMAAAAgABT21Z4QAAAABJRU5ErkJggg==" data-src="https://bkimg.cdn.bcebos.com/pic/6609c93d70cf3bc71c68c54dd100baa1cd112a22?x-bce-process=image/resize,m_lfit,w_1280,limit_1/format,f_auto" alt="" style="width:640px;height:387.41839762611px;"> </a>
//        </div>
//        </div>
//        <div class="para" label-module="para">
//        以上是最基本的选择器语法，这些语法也可以组合起来使用，下面是jsoup支持的组合用法：
//        </div>
//        <div class="para" label-module="para">
//        <div class="lemma-picture J-lemma-picture text-pic layout-center" style="width:640px; float: none; display: block; margin: 0px auto; clear: both;">
//        <a class="image-link" nslog-type="9317" href="/pic/jsoup/9012509/0/a71ea8d3fd1f4134e04e0ddf251f95cad1c85e11?fr=lemma&amp;ct=single" target="_blank" title="" style="width:640px;height:302.35469448584px;"> <img class="lazy-img" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAMAAAAoyzS7AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAAZQTFRF9fX1AAAA0VQI3QAAAAxJREFUeNpiYAAIMAAAAgABT21Z4QAAAABJRU5ErkJggg==" data-src="https://bkimg.cdn.bcebos.com/pic/a71ea8d3fd1f4134e04e0ddf251f95cad1c85e11?x-bce-process=image/resize,m_lfit,w_1280,limit_1/format,f_auto" alt="" style="width:640px;height:302.35469448584px;"> </a>
//        </div>
//        </div>
//        <div class="para" label-module="para">
//        除了一些基本的语法以及这些语法进行组合外，jsoup 还支持使用
//        <a target="_blank" href="/item/%E8%A1%A8%E8%BE%BE%E5%BC%8F">表达式</a>进行元素过滤选择。下面是jsoup支持的所有表达式一览表：
//        </div>
//        <div class="para" label-module="para">
//        <div class="lemma-picture J-lemma-picture text-pic layout-center" style="width:640px; float: none; display: block; margin: 0px auto; clear: both;">
//        <a class="image-link" nslog-type="9317" href="/pic/jsoup/9012509/0/38dbb6fd5266d016a9619689972bd40735fa3512?fr=lemma&amp;ct=single" target="_blank" title="" style="width:640px;height:265.1564828614px;"> <img class="lazy-img" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAMAAAAoyzS7AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAAZQTFRF9fX1AAAA0VQI3QAAAAxJREFUeNpiYAAIMAAAAgABT21Z4QAAAABJRU5ErkJggg==" data-src="https://bkimg.cdn.bcebos.com/pic/38dbb6fd5266d016a9619689972bd40735fa3512?x-bce-process=image/resize,m_lfit,w_1280,limit_1/format,f_auto" alt="" style="width:640px;height:265.1564828614px;"> </a>
//        </div>
//        </div>
//        <div class="anchor-list ">
//        <a name="3" class="lemma-anchor para-title"></a>
//        <a name="sub4066913_3" class="lemma-anchor "></a>
//        <a name="总结" class="lemma-anchor "></a>
//        </div>
//        <div class="para-title level-2  J-chapter" data-index="3" label-module="para-title">
//        <h2 class="title-text"><span class="title-prefix">jsoup</span>总结</h2>
//        <a class="edit-icon j-edit-link" data-edit-dl="3" href="javascript:;"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_edit-lemma"></em>编辑</a>
//        <a class="audio-play part-audio-play J-part-audio-play" href="javascript:;"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_audio"></em> <span class="J-part-audio-text">语音</span> </a>
//        </div>
//        <div class="para" label-module="para">
//        jsoup 的基本功能到这里就介绍完毕，但由于jsoup 良好的可扩展性API 设计，你可以通过选择器的定义来开发出非常强大的HTML 解析功能。再加上jsoup 项目本身的开发也非常活跃，因此如果你正在使用Java ，需要对HTML 进行处理，不妨试试。
//        </div>
//        <div id="J-main-content-end-dom"></div>
//        <div class="anchor-list ">
//        <a name="album-list" class="lemma-anchor "></a>
//        </div>
//        <div class="album-list">
//        <div class="header">
//        <span class="title">词条图册</span>
//        <a class="more-link" href="/pic/jsoup/9012509?fr=lemma" target="_blank" nslog-type="10000204">更多图册<em></em></a>
//        </div>
//        <div class="scroller">
//        <div class="list">
//        </div>
//        </div>
//        <div class="footer">
//        </div>
//        </div>
//        </div>
//        <div class="side-content">
//        <div class="summary-pic">
//        <a nslog-type="10002401" href="/pic/jsoup/9012509/1/1e30e924b899a9011fcfd12f16950a7b0208f535?fr=lemma&amp;ct=single" target="_blank"> <img src="https://bkimg.cdn.bcebos.com/pic/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image/resize,m_lfit,w_268,limit_1/format,f_jpg" alt="jsoup"> <button class="picAlbumBtn"><em></em><span>图集</span></button>
//        <div>
//        jsoup的概述图（1张）
//        </div> </a>
//        </div>
//        <div class="lemmaWgt-promotion-vbaike">
//        <div class="promotion_title">
//        V百科
//        <a href="/vbaike#gallary" target="_blank">往期回顾</a>
//        </div>
//        <div class="promotion_viewport">
//        <dl>
//        </dl>
//        <div class="promotion_viewport_pager"></div>
//        </div>
//        </div>
//        <div class="lemmaWgt-promotion-rightPreciseAd" data-lemmaid="9012509" data-lemmatitle="jsoup"></div>
//        <div class="lemmaWgt-sideRecommend">
//        <a name="zhixinWrap" class="qnAnchor"></a>
//        <div class="zhixin-box" id="zhixinWrap" data-source="" data-newlemmaid="9012509">
//        </div>
//        <form id="zhixinErrorForm" class="hidden" action="https://sp2.baidu.com/-uV1bjeh1BF3odCf/index.php/feedback/zx/baikeJC" target="zhixinSubErr" method="post">
//        <input class="js-url" name="fb_html_url" type="hidden">
//        <input class="js-query" name="fb_query" type="hidden">
//        <input class="js-title" name="fb_card_title" type="hidden">
//        <input class="js-content" name="fb_content" type="hidden">
//        <input class="js-souceId" name="fb_source_id" type="hidden">
//        </form>
//        <iframe id="zhixinSubErr" name="zhixinSubErr" style="display:none" frameborder="0"></iframe>
//        </div>
//        <div class="lemmaWgt-promotion-slide">
//        <div class="promotion_viewport">
//        <dl>
//        </dl>
//        <div class="promotion_viewport_pager"></div>
//        </div>
//        </div>
//        <div class="lemmaWgt-promotion-rightBigAd">
//        </div>
//        <dl class="side-box lemma-statistics">
//        <dt class="title">
//        词条统计
//        </dt>
//        <dd class="description split-line">
//        <ul>
//        <li>浏览次数：<span id="j-lemmaStatistics-pv"></span>次</li>
//        <li>编辑次数：13次<a href="/historylist/jsoup/9012509" class="nslog:1021" target="_blank">历史版本</a></li>
//        <li> <span class="latest-title">最近更新：</span> <span class="latest-content"> <a class="show-userCard" data-uid="2977826543" title="查看此用户资料" target="_blank" href="/usercenter/userpage?uname=%E7%82%8E%E7%81%AB%E7%81%AB%E6%9E%97&amp;from=lemma" nslog-type="1022">炎火火林</a><a href="https://baike.baidu.com/kedou" title="百科蝌蚪团" target="_blank" class="contribute-flag-container"> <img src="https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/lemmaStatistics/img/contribute-flag-1_c1b820f.png" alt="" class="contribute-flag-icon"> </a> <span class="j-modified-time" style="display:none">（2021-05-06）</span> </span> </li>
//        </ul>
//        </dd>
//        <dt class="title">
//        突出贡献榜
//        </dt>
//        <dd class="description excellent-description">
//        <ul>
//        <li> <a title="查看此用户资料" class="usercard show-userCard" data-uid="330360747" username="javayuan920" target="_blank" href="/usercenter/userpage?uname=javayuan920&amp;from=lemma">javayuan920</a>
//        <div class="right">
//        <a target="_blank" href="https://baike.baidu.com/item/%E7%99%BE%E5%BA%A6%E7%99%BE%E7%A7%91%EF%BC%9A%E5%88%9B%E5%BB%BA%E7%89%88%E6%9C%AC"><img align="absmiddle" alt="创建版本" title="创建版本" src="https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/lemmaStatistics/img/create_c3f33b6.png"></a>
//        </div> </li>
//        </ul>
//        </dd>
//        </dl>
//        <div class="side-catalog" style="visibility:hidden">
//        <div class="side-bar">
//        <em class="circle start"></em>
//        <em class="circle end"></em>
//        </div>
//        <div class="catalog-scroller">
//        <dl class="catalog-list">
//        <dt class="catalog-title level1">
//        <em class="pointer"></em>
//        <a href="#1" class="title-link"> <span class="text"> <span class="title-index">1</span> <span class="title-link" nslog-type="10002802">内容简介</span> </span> </a>
//        </dt>
//        <dt class="catalog-title level1">
//        <em class="pointer"></em>
//        <a href="#2" class="title-link"> <span class="text"> <span class="title-index">2</span> <span class="title-link" nslog-type="10002802">主要功能</span> </span> </a>
//        </dt>
//        <dt class="catalog-title level1">
//        <em class="pointer"></em>
//        <a href="#3" class="title-link"> <span class="text"> <span class="title-index">3</span> <span class="title-link" nslog-type="10002802">总结</span> </span> </a>
//        </dt>
//        <a class="arrow" href="javascript:void(0);"></a>
//        </dl>
//        </div>
//        <div class="right-wrap">
//        <a class="go-up disable" href="javascript:void(0);"></a>
//        <a class="go-down" href="javascript:void(0);"></a>
//        </div>
//        </div>
//        <div id="side_box_fengchao" class="fengchao side-box" nslog="area" nslog-type="10000902">
//        </div>
//        <div id="side_box_unionAd" class="unionAd">
//        <div class="union-content"></div>
//        </div>
//        <div id="J-side-box-yitiao" class="side-box yitiao-box">
//        <div class="recommend-title">
//        为您推荐
//        <span class="recommend-flag">广告</span>
//        </div>
//        <div class="recommend-content"></div>
//        </div>
//        </div>
//        </div>
//        </div>
//        <div class="after-content">
//        <div class="bottom-recommend-wrapper"></div>
//        <div class="fc-guess-like new" id="fc_guess_like_new">
//        <span class="logo-du"> <em class="cmn-icon cmn-icons cmn-icons_logo-du"></em> </span>
//        <h6>搜索发现</h6>
//        <ul class="cmn-clearfix">
//        </ul>
//        </div>
//        </div>
//        </div>
//        <div class="wgt-footer-main">
//        <div class="content">
//        <dl class="fresh">
//        <dt>
//        <em class="cmn-icon cmn-icons cmn-icons_footer-fresh"></em>新手上路
//        </dt>
//        <dd>
//        <div>
//        <a target="_blank" href="/usercenter/tasks#guide">成长任务</a>
//        </div>
//        <div>
//        <a target="_blank" href="/help#main01">编辑入门</a>
//        </div>
//        <div>
//        <a target="_blank" href="/help#main06">编辑规则</a>
//        </div>
//        <div>
//        <a target="_blank" href="/item/%E7%99%BE%E5%BA%A6%E7%99%BE%E7%A7%91%EF%BC%9A%E6%9C%AC%E4%BA%BA%E8%AF%8D%E6%9D%A1%E7%BC%96%E8%BE%91%E6%9C%8D%E5%8A%A1/22442459?bk_fr=pcFooter">本人编辑</a>
//        <img src="https://bkssl.bdimg.com/static/wiki-common/widget/component/footer/img/new-icon_a64774d.png" class="new-icon" alt="new">
//        </div>
//        </dd>
//        </dl>
//        <dl class="question">
//        <dt>
//        <em class="cmn-icon cmn-icons cmn-icons_footer-question"></em>我有疑问
//        </dt>
//        <dd>
//        <div>
//        <a id="J-bk-feedback-query" data-lemma="jsoup" href="javascript:void(0);" nslog-type="10070001" data-type="feedback">内容质疑</a>
//        </div>
//        <div>
//        <a class="J-bk-online-service" target="_blank" href="http://zhiqiu.baidu.com/baike/passport/html/baikechat.html" nslog-type="10000003">在线客服</a>
//        </div>
//        <div>
//        <a target="_blank" href="http://tieba.baidu.com/f?ie=utf-8&amp;fr=bks0000&amp;kw=%E7%99%BE%E5%BA%A6%E7%99%BE%E7%A7%91">官方贴吧</a>
//        </div>
//        <div>
//        <a id="J-bk-feedback-main" href="javascript:void(0);">意见反馈</a>
//        </div>
//        </dd>
//        </dl>
//        <dl class="suggestion">
//        <dt>
//        <em class="cmn-icon cmn-icons cmn-icons_footer-suggestion"></em>投诉建议
//        </dt>
//        <dd>
//        <div>
//        <a target="_blank" href="http://help.baidu.com/newadd?prod_id=10&amp;category=1">举报不良信息</a>
//        </div>
//        <div>
//        <a target="_blank" href="http://help.baidu.com/newadd?prod_id=10&amp;category=2">未通过词条申诉</a>
//        </div>
//        <div>
//        <a target="_blank" href="http://help.baidu.com/newadd?prod_id=10&amp;category=6">投诉侵权信息</a>
//        </div>
//        <div>
//        <a target="_blank" href="http://help.baidu.com/newadd?prod_id=10&amp;category=5">封禁查询与解封</a>
//        </div>
//        </dd>
//        </dl>
//        </div>
//        <div class="copyright">
//        ©2021&nbsp;Baidu&nbsp;
//        <a href="http://www.baidu.com/duty/" target="_blank">使用百度前必读</a>&nbsp;|&nbsp;
//        <a href="http://help.baidu.com/question?prod_en=baike&amp;class=89&amp;id=1637" target="_blank">百科协议</a>&nbsp;|&nbsp;
//        <a href="http://help.baidu.com/question?prod_id=10&amp;class=690&amp;id=1001779" target="_blank">隐私政策</a>&nbsp;|&nbsp;
//        <a href="/operation/cooperation" target="_blank">百度百科合作平台</a>&nbsp;|&nbsp;
//        <span>京ICP证030173号&nbsp;</span>
//        <img class="copyright-img" width="13" height="16" src="https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/copy_rignt_24.png">
//        </div>
//        <p class="recordcode"><a href="http://www.beian.gov.cn/portal/registerSystemInfo?recordcode=11000002000001" target="_blank"><i class="icon-police"></i>京公网安备11000002000001号</a></p>
//        </div>
//        <div class="lemmaWgt-searchHeader">
//        <div class="layout cmn-clearfix">
//        <div class="wgt-searchbar wgt-searchbar-new wgt-searchbar-simple cmn-clearfix ">
//        <div class="logo-container">
//        <a class="logo cmn-inline-block" title="到百科首页" href="/"> <span class="cmn-baike-logo"> <em class="cmn-icon cmn-icons cmn-icons_logo-bai"></em> <em class="cmn-icon cmn-icons cmn-icons_logo-du"></em> <em class="cmn-icon cmn-icons cmn-icons_logo-baike"></em> </span> </a>
//        </div>
//        <div class="search">
//        <div class="form">
//        <form id="searchForm" action="/search/word" method="GET" target="_self">
//        <input id="query" nslog="normal" nslog-type="10080015" name="word" type="text" autocomplete="off" autocorrect="off" value="jsoup">
//        <button id="search" nslog="normal" nslog-type="10080013" type="button">进入词条</button>
//        </form>
//        <form id="searchLemmaForm" action="/search" method="GET" target="_self">
//        <input id="searchLemmaQuery" name="word" type="hidden">
//        <input name="pn" type="hidden" value="0">
//        <input name="rn" type="hidden" value="0">
//        <input name="enc" type="hidden" value="utf8">
//        </form>
//        <ul id="suggestion" class="suggestion">
//        <div class="sug"></div>
//        <li class="extra"> <span id="clear" style="margin-right:8px;">清除历史记录</span><span id="close" nslog="normal" nslog-type="10080016">关闭</span> </li>
//        </ul>
//        </div>
//        </div>
//        </div>
//        <div class="tool-buttons">
//        <a class="toolButtons-audio button audio-play header-audio-play J-header-audio-play" javascript=":;"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_audio"></em><span class="J-audio-text">语音</span></a>
//        <a class="toolButtons-edit button j-edit-link" href="javascript:;" nslog-type="10010001"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_edit-hollow"></em>编辑</a>
//        <a class="toolButtons-discussion button j-discussion-link" href="/planet/talk?lemmaId=9012509" target="_blank" nslog-type="90000103"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_discussion-hollow"></em>讨论&nbsp;<span class="num"></span></a>
//        <a class="toolButtons-collect button" href="javascript:;" nslog-type="10010002"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_star-hollow"></em><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_star-solid"></em>收藏</a>
//        <a class="toolButtons-vote button top-vote" href="javascript:;" nslog-type="10010003"><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_zan-hollow"></em><em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_zan-solid"></em><span class="j-tool-btn-vote-num">赞</span></a>
//        </div>
//        <div class="user-info">
//        <a class="user-link unlogin" href="javascript:;" nslog-type="10010008" target="_blank">登录</a>
//        </div>
//        </div>
//        </div>
//        <div class="new-bdsharebuttonbox new-side-share" id="side-share">
//        <div class="share-list">
//        <a id="J-bds_task" class="bds_task" target="_blank" href="https://baike.baidu.com/task" nslog-type="10060902"></a>
//        <a class="share-link bds_qzone" href="javascript:void(0);" nslog-type="10060101"> <em class="cmn-icon cmn-icons cmn-icons_logo-qzone"></em> </a>
//        <a class="share-link bds_tsina" href="javascript:void(0);" nslog-type="10060301"> <em class="cmn-icon cmn-icons cmn-icons_logo-sina-weibo"></em> </a>
//        <a class="bds_wechat" href="javascript:void(0);" nslog-type="10060001"> <em class="cmn-icon cmn-icons cmn-icons_logo-wechat"></em> </a>
//        <a class="share-link bds_tqq" href="javascript:void(0);" nslog-type="10060201"> <em class="cmn-icon cmn-icons cmn-icons_logo-qq"></em> </a>
//        <a id="J-bds_app" class="bds_app" href="javascript:void(0);" nslog-type="10060901"> <em class="cmn-icon cmn-icons cmn-icons_mobile-phone"></em> </a>
//        </div>
//        <div class="go-top">
//        <em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_up-arrow"></em>
//        </div>
//        <div id="J-task-tip" class="task-tip"></div>
//        <div id="J-app-download" class="app-download hide">
//        <div class="text">
//        <h3 class="main">扫码下载百科APP</h3>
//        <h4 class="sub">领取<b>50</b>财富值奖励</h4>
//        </div>
//        <div class="qrcode"></div>
//        </div>
//        </div>
//        <div class="qrcode-wrapper" id="layer" style="display: none">
//        <div class="bd_weixin_popup_header">
//        <em class="cmn-icon cmn-icons cmn-icons_close"></em>
//        <span>分享到微信朋友圈</span>
//        </div>
//        <div id="wechat-qrcode-img"></div>
//        <div class="bd_weixin_popup_footer">
//        打开微信“扫一扫”即可将网页分享至朋友圈
//        </div>
//        </div>
//        <div></div>
//        <div></div>
//        <div id="J-audio-container" class="audio-container">
//        <div class="audio-item audio-avatar audio-link">
//        <img draggable="false" src="https://bkimg.cdn.bcebos.com/pic/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image/resize,m_lfit,w_268,limit_1/format,f_auto">
//        </div>
//        <div class="audio-item audio-title J-audio-title">
//        <span class="J-scroll-begin J-audio-link"></span>
//        <span class="J-scroll-end J-audio-link"></span>
//        </div>
//        <div class="audio-item audio-control-icon">
//        <em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_audio-play" id="J-audio-stop"></em>
//        <em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_audio-setting" id="J-audio-setting"></em>
//        <em class="cmn-icon wiki-lemma-icons wiki-lemma-icons_close" id="J-audio-close"></em>
//        </div>
//        <div class="audio-progress J-audio-progress"></div>
//        <div class="audio-select J-audio-select">
//        <p class="audio-select-header">选择朗读音色</p>
//        <ul class="">
//        </ul>
//        </div>
//        <audio class="audio-core J-audio-core" id="J-audio-current" preload="auto"></audio>
//        <audio class="audio-core J-audio-core" id="J-audio-cache" preload="auto"></audio>
//        </div>
//        <script>
//        window['__abbaidu_2020_subidgetf'] = function () {
//        var subid = 'baike_pc_lemmapage';
//        return subid;
//        };
//        window['__abbaidu_2020_cb'] = function (res) {
//        document.cookie = 'BAIKE_SHITONG=' + encodeURIComponent(res) + '; path=/item; max-age=86400';
//        }
//        </script>
//        <script>
//        if (!window['__abbaidu_2020_subidgetf']) {
//        window['__abbaidu_2020_subidgetf'] = function () {
//        var subid = 01000000;
//        return subid;
//        };
//        }
//        </script>
//        <script async src="https://dlswbr.baidu.com/heicha/mw/abclite-2020-s.js"></script>
//        <script type="text/javascript" src="https://bkssl.bdimg.com/static/wiki-common/js/mod_4302fe0.js"></script>
//        <script type="text/javascript">require.resourceMap({"res":{"wiki-common:widget/lib/jquery/jquery_1.11.1.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/jquery/jquery_1.11.1_dfce600.js","pkg":"wiki-common:p1"},"wiki-common:widget/lib/jquery/jquery.mousewheel.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/jquery/jquery.mousewheel_4fde694.js","pkg":"wiki-common:p1"},"wiki-common:widget/lib/jquery/jquery.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/jquery/jquery_2d56800.js","pkg":"wiki-common:p1","deps":["wiki-common:widget/lib/jquery/jquery_1.11.1.js","wiki-common:widget/lib/jquery/jquery.mousewheel.js"]},"wiki-common:widget/util/browser.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/browser_0cae792.js","pkg":"wiki-common:p1"},"wiki-common:widget/component/psLink/psLink.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/psLink/psLink_b04245f.js","pkg":"wiki-common:p1","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/browser.js"]},"wiki-common:widget/lib/jsmart/PHPJS.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/jsmart/PHPJS_2406ddf.js","pkg":"wiki-common:p2"},"wiki-common:widget/lib/jsmart/jsmart.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/jsmart/jsmart_3b0d707.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jsmart/PHPJS.js"]},"wiki-common:widget/lib/sparkMD5/sparkMD5.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/sparkMD5/sparkMD5_a5502a8.js","pkg":"wiki-common:p2"},"wiki-common:widget/util/cookie.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/cookie_d65a55c.js","pkg":"wiki-common:p2"},"wiki-common:widget/util/guid.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/guid_f133529.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/sparkMD5/sparkMD5.js","wiki-common:widget/util/cookie.js"]},"wiki-common:widget/component/nslog/nslog.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/nslog/nslog_0c50dab.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/component/share/dep/qrcode.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/share/dep/qrcode_31e7587.js","pkg":"wiki-common:p2"},"wiki-common:widget/component/baikeAppPromote/baikeAppPromote.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/baikeAppPromote/baikeAppPromote.es_5a27a23.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/util/guid.js","wiki-common:widget/component/nslog/nslog.js","wiki-common:widget/component/share/dep/qrcode.js"]},"wiki-common:widget/component/cmsModuleLoader/cmsModuleLoader.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/cmsModuleLoader/cmsModuleLoader_9266729.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/component/evtMsgManager/event.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/evtMsgManager/event_9521995.js","pkg":"wiki-common:p2"},"wiki-common:widget/util/eventEmitter.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/eventEmitter_1c6cdcb.js","pkg":"wiki-common:p2"},"wiki-common:widget/component/evtMsgManager/evtMsgManager.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/evtMsgManager/evtMsgManager.es_b075087.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/util/eventEmitter.js","wiki-common:widget/component/evtMsgManager/event.js"]},"wiki-common:widget/component/footer/footer_feedback.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/footer/footer_feedback_0cd49ef.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/component/headTabBar/headTabBar.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/headTabBar/headTabBar_61cfd37.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/util/safeCall.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/safeCall_40b36d9.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/ui/tagsInput/tagsInput.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/tagsInput/tagsInput_0f185ac.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/util/safeCall.js"]},"wiki-common:widget/util/tween.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/tween_bbf493a.js","pkg":"wiki-common:p2"},"wiki-common:widget/util/animation.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/animation_99fcf68.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/tween.js","wiki-common:widget/util/safeCall.js"]},"wiki-common:widget/ui/overlay/overlay.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/overlay/overlay_0793dbc.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/util/animation.js"]},"wiki-common:widget/util/checkCSS.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/checkCSS_71655dd.js","pkg":"wiki-common:p2"},"wiki-common:widget/ui/bubble/bubble.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/bubble/bubble_5e87036.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/safeCall.js"]},"wiki-common:widget/ui/dialog/windowScroll.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialog/windowScroll_04f4ad0.js","pkg":"wiki-common:p2"},"wiki-common:widget/ui/dialog/dialog.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialog/dialog_31ae5e5.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/ui/overlay/overlay.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/util/animation.js","wiki-common:widget/util/checkCSS.js","wiki-common:widget/ui/bubble/bubble.js","wiki-common:widget/ui/dialog/windowScroll.js"]},"wiki-common:widget/component/lemmasInput-n/lemmasInput-n.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/lemmasInput-n/lemmasInput-n_3326b1a.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/ui/tagsInput/tagsInput.js","wiki-common:widget/ui/dialog/dialog.js"]},"wiki-common:widget/util/number.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/number_e565676.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/util/timeFormater.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/timeFormater_26237da.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/util/number.js"]},"wiki-common:widget/util/string.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/string_aebe4aa.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/timeFormater.js"]},"wiki-common:widget/component/lemmasInput/lemmasInput.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/lemmasInput/lemmasInput_79cd028.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/util/string.js","wiki-common:widget/ui/tagsInput/tagsInput.js","wiki-common:widget/ui/dialog/dialog.js"]},"wiki-common:widget/component/picUploader/Jcrop/Jcrop.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/picUploader/Jcrop/Jcrop_6b72956.js","pkg":"wiki-common:p2"},"wiki-common:widget/ui/picUploader/Jcrop/Jcrop.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/picUploader/Jcrop/Jcrop_d13028b.js","pkg":"wiki-common:p2"},"wiki-common:widget/component/picUploader/picCropper.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/picUploader/picCropper_b9bb878.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/ui/picUploader/Jcrop/Jcrop.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/util/safeCall.js"]},"wiki-common:widget/component/picUploader/picUploader.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/picUploader/picUploader_406550d.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/util/safeCall.js"]},"wiki-common:widget/component/recruitment/recruitment.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/recruitment/recruitment_4f2b7a0.js","pkg":"wiki-common:p2"},"wiki-common:widget/component/searchbar-n/searchbar.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/searchbar-n/searchbar_1dc65bc.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/browser.js","wiki-common:widget/util/cookie.js"]},"wiki-common:widget/component/searchbar/searchbar.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/searchbar/searchbar_8e85f3d.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/browser.js"]},"wiki-common:widget/util/url.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/url_9b97169.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/component/share/share.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/share/share_99b068c.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/component/share/dep/qrcode.js","wiki-common:widget/util/url.js","wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:node_modules/promise-polyfill/lib/polyfill.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/promise-polyfill/lib/polyfill_ce73cb7.js","pkg":"wiki-common:p2"},"wiki-common:widget/component/superLogger/superLogger.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/superLogger/superLogger.es_a1ee138.js","pkg":"wiki-common:p2","deps":["wiki-common:node_modules/promise-polyfill/lib/polyfill.js","wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/component/testElem/testElem.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/testElem/testElem_a52d423.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/util/string.js","wiki-common:widget/component/nslog/nslog.js"]},"wiki-common:widget/component/unameFiller/unameFiller.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/unameFiller/unameFiller_b8922ce.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/ui/dialog/dialog.js"]},"wiki-common:widget/component/uploadImg/uploadImg.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/uploadImg/uploadImg_0bacf6a.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/component/urls/getLemmaUrl.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/urls/getLemmaUrl_526947f.js","pkg":"wiki-common:p2"},"wiki-common:widget/component/userLogin/userLogin.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/userLogin/userLogin_e63d1b3.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/component/userbar-n/userbar-n.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/userbar-n/userbar-n_ea93b01.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/userLogin/userLogin.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/util/browser.js","wiki-common:widget/ui/bubble/bubble.js"]},"wiki-common:widget/component/userCard/userCard.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/userCard/userCard_a1a41e0.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/ui/bubble/bubble.js"]},"wiki-common:widget/component/userMsg/userMsg.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/component/userMsg/userMsg_ad950d8.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/userLogin/userLogin.js"]},"wiki-common:widget/lib/clipboard/clipboard.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/clipboard/clipboard_be46868.js","pkg":"wiki-common:p2"},"wiki-common:widget/lib/echarts/echarts.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/echarts/echarts_4985dc5.js","pkg":"wiki-common:p2"},"wiki-common:widget/lib/echarts/echarts-wordcloud.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/echarts/echarts-wordcloud_2fe9397.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/echarts/echarts.js"]},"wiki-common:widget/lib/hls/hls.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/hls/hls_c8e6815.js","pkg":"wiki-common:p2"},"wiki-common:widget/lib/kinetic/kinetic.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/kinetic/kinetic_3813cb6.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/dom-walk/index.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/dom-walk/index_619e040.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/min-document/dom-comment.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/min-document/dom-comment_63fcf61.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/min-document/dom-text.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/min-document/dom-text_8326e56.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/min-document/event/dispatch-event.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/min-document/event/dispatch-event_966cb54.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/min-document/event/add-event-listener.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/min-document/event/add-event-listener_32dccf3.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/min-document/event/remove-event-listener.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/min-document/event/remove-event-listener_6c90676.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/min-document/serialize.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/min-document/serialize_52bc56e.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/min-document/dom-element.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/min-document/dom-element_a9609d5.js","pkg":"wiki-common:p2","deps":["wiki-common:node_modules/dom-walk/index.js","wiki-common:node_modules/min-document/event/dispatch-event.js","wiki-common:node_modules/min-document/event/add-event-listener.js","wiki-common:node_modules/min-document/event/remove-event-listener.js","wiki-common:node_modules/min-document/serialize.js"]},"wiki-common:node_modules/min-document/dom-fragment.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/min-document/dom-fragment_c921c01.js","pkg":"wiki-common:p2","deps":["wiki-common:node_modules/min-document/dom-element.js"]},"wiki-common:node_modules/min-document/event.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/min-document/event_0227ad4.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/min-document/document.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/min-document/document_b9c3e87.js","pkg":"wiki-common:p2","deps":["wiki-common:node_modules/dom-walk/index.js","wiki-common:node_modules/min-document/dom-comment.js","wiki-common:node_modules/min-document/dom-text.js","wiki-common:node_modules/min-document/dom-element.js","wiki-common:node_modules/min-document/dom-fragment.js","wiki-common:node_modules/min-document/event.js","wiki-common:node_modules/min-document/event/dispatch-event.js","wiki-common:node_modules/min-document/event/add-event-listener.js","wiki-common:node_modules/min-document/event/remove-event-listener.js"]},"wiki-common:node_modules/min-document/index.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/min-document/index_7ae362d.js","pkg":"wiki-common:p2","deps":["wiki-common:node_modules/min-document/document.js"]},"wiki-common:node_modules/global/document.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/global/document_61613fa.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/object-assign/index.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/object-assign/index_7b32f15.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/weakmap-polyfill/weakmap-polyfill.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/weakmap-polyfill/weakmap-polyfill_3f5a6d0.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/global/window.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/global/window_5532055.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/lodash.includes/index.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/lodash.includes/index_f964055.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/array-find/find.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/array-find/find_59d7766.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/lodash.values/index.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/lodash.values/index_536c740.js","pkg":"wiki-common:p2"},"wiki-common:node_modules/larkplayer/dist/larkplayer.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/larkplayer/dist/larkplayer_970c098.js","pkg":"wiki-common:p2","deps":["wiki-common:node_modules/min-document/index.js","wiki-common:node_modules/global/document.js","wiki-common:node_modules/object-assign/index.js","wiki-common:node_modules/weakmap-polyfill/weakmap-polyfill.js","wiki-common:node_modules/global/window.js","wiki-common:node_modules/lodash.includes/index.js","wiki-common:node_modules/array-find/find.js","wiki-common:node_modules/lodash.values/index.js"]},"wiki-common:node_modules/hls.js/dist/hls.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/hls.js/dist/hls_78abf63.js","pkg":"wiki-common:p2"},"wiki-common:widget/lib/larkplayer/larkplayer-hls.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/larkplayer/larkplayer-hls_c1f8708.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:node_modules/larkplayer/dist/larkplayer.js","wiki-common:node_modules/hls.js/dist/hls.js"]},"wiki-common:widget/lib/larkplayer/larkplayer-play-continue.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/larkplayer/larkplayer-play-continue_45bac94.js","pkg":"wiki-common:p2","deps":["wiki-common:node_modules/larkplayer/dist/larkplayer.js"]},"wiki-common:node_modules/@baidu/clickstream-sdk/lib/index.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/@baidu/clickstream-sdk/lib/index_3ecd43d.js","pkg":"wiki-common:p2"},"wiki-common:widget/util/clickstreamSdk.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/clickstreamSdk_24721db.js","pkg":"wiki-common:p2","deps":["wiki-common:node_modules/@baidu/clickstream-sdk/lib/index.js"]},"wiki-common:widget/tools/clickstream/clickstream.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/tools/clickstream/clickstream_7ac9fcb.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/util/clickstreamSdk.js"]},"wiki-common:widget/lib/larkplayer/larkplayer-play-via-second-id.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/larkplayer/larkplayer-play-via-second-id_b0a60d0.js","pkg":"wiki-common:p2","deps":["wiki-common:node_modules/larkplayer/dist/larkplayer.js","wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/nslog/nslog.js","wiki-common:widget/component/superLogger/superLogger.es.js","wiki-common:widget/tools/clickstream/clickstream.js"]},"wiki-common:widget/lib/larkplayer/larkplayer-playback-rate.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/larkplayer/larkplayer-playback-rate_7eabefd.js","pkg":"wiki-common:p2","deps":["wiki-common:node_modules/larkplayer/dist/larkplayer.js","wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/lib/larkplayer/larkplayer-window-player.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/larkplayer/larkplayer-window-player_1819a96.js","pkg":"wiki-common:p2","deps":["wiki-common:node_modules/larkplayer/dist/larkplayer.js","wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:node_modules/larkplayer-ui/dist/larkplayer-ui.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/node_modules/larkplayer-ui/dist/larkplayer-ui_2693a4a.js","pkg":"wiki-common:p2","deps":["wiki-common:node_modules/larkplayer/dist/larkplayer.js"]},"wiki-common:widget/lib/larkplayer/larkplayer.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/larkplayer/larkplayer_1b76876.js","pkg":"wiki-common:p2","deps":["wiki-common:node_modules/larkplayer/dist/larkplayer.js","wiki-common:widget/lib/larkplayer/larkplayer-hls.js","wiki-common:node_modules/larkplayer-ui/dist/larkplayer-ui.js","wiki-common:widget/lib/larkplayer/larkplayer-play-continue.js","wiki-common:widget/lib/larkplayer/larkplayer-play-via-second-id.js","wiki-common:widget/lib/larkplayer/larkplayer-window-player.js","wiki-common:widget/lib/larkplayer/larkplayer-playback-rate.js"]},"wiki-common:widget/lib/letvPlayer/letvPlayer.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/letvPlayer/letvPlayer_f923883.js","pkg":"wiki-common:p2"},"wiki-common:widget/lib/shim/shim.min.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/shim/shim.min_ec3c39c.js","pkg":"wiki-common:p2"},"wiki-common:widget/lib/swfObject/swfObject.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/swfObject/swfObject_00526c3.js","pkg":"wiki-common:p2"},"wiki-common:widget/lib/webuploader/webuploader.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/webuploader/webuploader_6073aff.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/lib/zeroClipboard/zeroClipboard.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/lib/zeroClipboard/zeroClipboard_1567e55.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/util/addStyleSheet.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/addStyleSheet_2db295b.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/ui/carousel/aniTypes/aniType_dissolve.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/carousel/aniTypes/aniType_dissolve_c112f2e.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/util/animation.js","wiki-common:widget/util/checkCSS.js","wiki-common:widget/util/addStyleSheet.js"]},"wiki-common:widget/ui/carousel/aniTypes/aniType_fade.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/carousel/aniTypes/aniType_fade_12be6a3.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/util/animation.js"]},"wiki-common:widget/ui/carousel/aniTypes/aniType_ripple.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/carousel/aniTypes/aniType_ripple_d16e461.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/util/animation.js","wiki-common:widget/util/checkCSS.js"]},"wiki-common:widget/ui/carousel/aniTypes/aniType_scale.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/carousel/aniTypes/aniType_scale_be5032b.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/util/animation.js","wiki-common:widget/util/checkCSS.js"]},"wiki-common:widget/ui/carousel/aniTypes/aniType_slide.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/carousel/aniTypes/aniType_slide_848a999.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/util/animation.js"]},"wiki-common:widget/ui/carousel/aniTypes/aniType_wipe.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/carousel/aniTypes/aniType_wipe_1e29046.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/util/animation.js","wiki-common:widget/util/checkCSS.js"]},"wiki-common:widget/ui/carousel/carousel.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/carousel/carousel_7b4b508.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/checkCSS.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/ui/carousel/aniTypes/aniType_slide.js","wiki-common:widget/util/number.js"]},"wiki-common:widget/ui/casecadeControl/casecadeControl.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/casecadeControl/casecadeControl_d086f85.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js"]},"wiki-common:widget/ui/counter/counter.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/counter/counter_42ebfde.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/util/animation.js","wiki-common:widget/util/number.js","wiki-common:widget/util/checkCSS.js"]},"wiki-common:widget/ui/datePicker/datePicker.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/datePicker/datePicker_0faf1a1.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/ui/bubble/bubble.js","wiki-common:widget/util/timeFormater.js","wiki-common:widget/util/checkCSS.js","wiki-common:widget/util/url.js","wiki-common:widget/util/safeCall.js"]},"wiki-common:widget/ui/dialogPlayer/constants.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/constants_2b0c705.js","pkg":"wiki-common:p2"},"wiki-common:widget/ui/dialogPlayer/eventful.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/eventful_554dd50.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/ui/dialogPlayer/dataManager.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/dataManager_6f18bba.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/ui/dialogPlayer/eventful.js","wiki-common:widget/ui/dialogPlayer/constants.js"]},"wiki-common:widget/ui/dialogPlayer/shareBubble/shareBubble.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/shareBubble/shareBubble_e910216.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/ui/bubble/bubble.js","wiki-common:widget/component/share/share.js","wiki-common:widget/component/share/dep/qrcode.js","wiki-common:widget/ui/dialogPlayer/eventful.js","wiki-common:widget/ui/dialogPlayer/constants.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/dom.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/dom_51fbb37.js","pkg":"wiki-common:p2"},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/class.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/class_1fdc00d.js","pkg":"wiki-common:p2"},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/helper.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/helper_6cfda97.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/class.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/dom.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/default-setting.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/default-setting_45e166c.js","pkg":"wiki-common:p2"},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/event-manager.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/event-manager_21498f9.js","pkg":"wiki-common:p2"},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/guid.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/guid_6a22c08.js","pkg":"wiki-common:p2"},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances_fb91ad6.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/class.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/dom.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/default-setting.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/event-manager.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/guid.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/helper.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/destroy.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/destroy_e35bb20.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/dom.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/helper.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-scroll.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-scroll_0a15e37.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-geometry.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-geometry_f1b1852.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/class.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/dom.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/helper.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/click-rail.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/click-rail_b0eb159.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/helper.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/drag-scrollbar.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/drag-scrollbar_cc14ed7.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/dom.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/helper.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/keyboard.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/keyboard_31b7847.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/helper.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/dom.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/mouse-wheel.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/mouse-wheel_69cd496.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/native-scroll.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/native-scroll_e87aa30.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-geometry.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/selection.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/selection_f7a5a3f.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/helper.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/touch.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/touch_16c2ed9.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/initialize.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/initialize_ecafb67.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/class.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/helper.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/click-rail.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/drag-scrollbar.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/keyboard.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/mouse-wheel.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/native-scroll.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/selection.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/handler/touch.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update_69db2c4.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/dom.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/lib/helper.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/main.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/main_0f0b1f4.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/destroy.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/initialize.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/update.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/index.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/index_87ad452.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/main.js"]},"wiki-common:widget/ui/dialogPlayer/perfectScrollbar.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/perfectScrollbar_f21f2df.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/util/browser.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/index.js","wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/ui/dialogPlayer/logMap.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/logMap_d5d2665.js","pkg":"wiki-common:p2"},"wiki-common:widget/ui/dialogPlayer/statistical.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/statistical_b900326.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/nslog/nslog.js","wiki-common:widget/ui/dialogPlayer/logMap.js"]},"wiki-common:widget/ui/dialogPlayer/dialogPlayer.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/dialogPlayer_2fbe0ba.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/larkplayer/larkplayer.js","wiki-common:widget/ui/dialog/dialog.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/ui/dialogPlayer/dataManager.js","wiki-common:widget/ui/dialogPlayer/shareBubble/shareBubble.js","wiki-common:widget/ui/dialogPlayer/perfectScrollbar.js","wiki-common:widget/ui/dialogPlayer/constants.js","wiki-common:widget/ui/dialogPlayer/eventful.js","wiki-common:widget/ui/dialogPlayer/statistical.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/adaptor/global.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/adaptor/global_18bfda3.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/main.js"]},"wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/adaptor/jquery.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/adaptor/jquery_d6cd417.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/main.js","wiki-common:widget/ui/dialogPlayer/third_party/perfect-scrollbar/src/js/plugin/instances.js"]},"wiki-common:widget/ui/flip/flip.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/flip/flip_48c30cc.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/checkCSS.js","wiki-common:widget/util/animation.js"]},"wiki-common:widget/ui/iqiyiPlayer/iqiyiPlayer.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/iqiyiPlayer/iqiyiPlayer_2d405a0.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/swfObject/swfObject.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/util/guid.js","wiki-common:widget/util/string.js"]},"wiki-common:widget/ui/marquee/marquee.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/marquee/marquee_9571b3b.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/util/animation.js"]},"wiki-common:widget/ui/pager/pagerBase.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/pager/pagerBase_b155d9d.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/safeCall.js"]},"wiki-common:widget/ui/pager/horPager/horPager.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/pager/horPager/horPager_a3ba2a7.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/ui/pager/pagerBase.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/util/safeCall.js"]},"wiki-common:widget/ui/picUploader/picUploader.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/picUploader/picUploader_2dd299d.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/ui/picUploader/Jcrop/Jcrop.js"]},"wiki-common:widget/util/color.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/color_0cc39a0.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/number.js"]},"wiki-common:widget/ui/pie/pie.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/pie/pie_9c990df.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/addStyleSheet.js","wiki-common:widget/util/browser.js","wiki-common:widget/util/color.js"]},"wiki-common:widget/ui/polyline/polyline.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/polyline/polyline_90aaeab.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/browser.js","wiki-common:widget/util/color.js","wiki-common:widget/util/animation.js","wiki-common:widget/util/number.js"]},"wiki-common:widget/ui/radar/radar.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/radar/radar_c8c2d39.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/browser.js","wiki-common:widget/util/color.js","wiki-common:widget/util/animation.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/util/number.js"]},"wiki-common:widget/ui/videoPlayer/videoPlayer.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/videoPlayer/videoPlayer_bebf9da.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/ui/iqiyiPlayer/iqiyiPlayer.js","wiki-common:widget/lib/letvPlayer/letvPlayer.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/util/guid.js","wiki-common:widget/util/timeFormater.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/lib/larkplayer/larkplayer.js"]},"wiki-common:widget/ui/videoDialog/videoDialog.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/ui/videoDialog/videoDialog_172e341.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/ui/dialog/dialog.js","wiki-common:widget/ui/videoPlayer/videoPlayer.js","wiki-common:widget/util/guid.js"]},"wiki-common:widget/util/calendar.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/calendar_20028a6.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/timeFormater.js","wiki-common:widget/util/safeCall.js"]},"wiki-common:widget/util/feedback.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/feedback_78fcf2d.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/util/getSrcByUrl.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/getSrcByUrl_d61a41e.js","pkg":"wiki-common:p2"},"wiki-common:widget/util/loadXaf.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/loadXaf_892b310.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/util/safeCall.js","wiki-common:widget/util/cookie.js","wiki-common:widget/lib/jquery/jquery.js"]},"wiki-common:widget/util/scrollTo.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/scrollTo_9c0cc13.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/browser.js","wiki-common:widget/util/animation.js"]},"wiki-common:widget/util/scrollToTop.js":{"url":"https://bkssl.bdimg.com/static/wiki-common/widget/util/scrollToTop_b1cddc8.js","pkg":"wiki-common:p2","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/scrollTo.js","wiki-common:widget/util/browser.js","wiki-common:widget/util/safeCall.js"]},"wiki-lemma:widget/feature/Audio/isCollide.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/feature/Audio/isCollide_e311bf7.js"},"wiki-lemma:widget/tools/bkshare/share.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/bkshare/share_3beba04.js","pkg":"wiki-lemma:p4"},"wiki-lemma:static/tools/bkshare.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/tools/bkshare_a2941a6.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-lemma:widget/tools/bkshare/share.js"]},"wiki-lemma:static/tools/durationLog.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/tools/durationLog_8030055.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/nslog/nslog.js"]},"wiki-lemma:static/tools/scriptLazyLoad.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/tools/scriptLazyLoad_eee6f6d.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/tools/announcement/announcement.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/announcement/announcement_f8dd02e.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/util/cookie.js"]},"wiki-lemma:widget/tools/bkclick/bkclick.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/bkclick/bkclick_0c6bb29.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/tools/clickstream/clickstream.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/clickstream/clickstream_80bcccf.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/util/clickstreamSdk.js"]},"wiki-lemma:widget/tools/eid/eid.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/eid/eid.es_61a06cb.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/util/cookie.js","wiki-common:widget/util/url.js"]},"wiki-lemma:widget/tools/inSightDetector/inSightDetector.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/inSightDetector/inSightDetector.es_2167643.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/tools/rangeExt/rangeExt.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/rangeExt/rangeExt_798a7db.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/tools/label/label.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/label/label_27e4b3e.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/util/browser.js","wiki-common:widget/ui/bubble/bubble.js","wiki-common:widget/ui/dialog/dialog.js","wiki-lemma:widget/tools/rangeExt/rangeExt.js"]},"wiki-lemma:widget/tools/lazyLoad/lazyLoad.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/lazyLoad/lazyLoad_075e9d1.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/tools/marquee/marquee.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/marquee/marquee_50fd4bd.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/tools/newSideShare/qrcode.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/newSideShare/qrcode_a30d942.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/tools/newSideShare/sideShare.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/newSideShare/sideShare_abcb5be.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/tools/newSideShare/taskSideShare.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/newSideShare/taskSideShare_00ad6a5.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-lemma:widget/tools/newSideShare/sideShare.js","wiki-lemma:widget/tools/newSideShare/qrcode.js","wiki-common:widget/component/nslog/nslog.js"]},"wiki-lemma:widget/tools/rightCheck/checkUgc.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/rightCheck/checkUgc_bf66dff.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/ui/dialog/dialog.js","wiki-common:widget/component/userLogin/userLogin.js","wiki-common:widget/component/unameFiller/unameFiller.js","wiki-common:widget/component/nslog/nslog.js","wiki-lemma:widget/tools/clickstream/clickstream.js"]},"wiki-lemma:widget/tools/rightCheck/rightCheck.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/rightCheck/rightCheck_6a532d3.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/safeCall.js","wiki-common:widget/component/userLogin/userLogin.js"]},"wiki-lemma:widget/tools/service/service.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/service/service_688d1e2.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/tools/searchHeader/toolButtons-n/toolButtons.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/searchHeader/toolButtons-n/toolButtons_827b876.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/userLogin/userLogin.js","wiki-lemma:widget/tools/service/service.js"]},"wiki-lemma:widget/tools/searchHeader/toolButtons-n/userInfo.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/searchHeader/toolButtons-n/userInfo_fb2faff.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/userLogin/userLogin.js"]},"wiki-lemma:widget/tools/searchHeader/toolButtons/toolButtons.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/searchHeader/toolButtons/toolButtons_3b55e42.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/userLogin/userLogin.js","wiki-lemma:widget/tools/service/service.js"]},"wiki-lemma:widget/tools/searchHeader/toolButtons/userInfo.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/searchHeader/toolButtons/userInfo_0f7cec4.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/userLogin/userLogin.js"]},"wiki-lemma:widget/tools/throttle/throttle.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/throttle/throttle.es_b3fd58d.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/tools/tool/debounce.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/tool/debounce_9aece8a.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/tools/tool/tool.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/tool/tool_0c386e5.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/tools/video/flashVideo/flashVideo.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/video/flashVideo/flashVideo_808154c.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/swfObject/swfObject.js"]},"wiki-lemma:widget/tools/video/iframeVideo/iframeVideo.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/video/iframeVideo/iframeVideo_6e5b775.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/tools/video/iqiyiVideo/iqiyiVideo.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/video/iqiyiVideo/iqiyiVideo_2bdb190.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-lemma:widget/tools/video/flashVideo/flashVideo.js"]},"wiki-lemma:widget/tools/video/pageMask/pageMask.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/video/pageMask/pageMask_f8ef928.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/tools/video/video.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/tools/video/video_c965528.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/tools/video/iframeVideo/iframeVideo.js","wiki-lemma:widget/tools/video/iqiyiVideo/iqiyiVideo.js","wiki-lemma:widget/tools/video/flashVideo/flashVideo.js"]},"wiki-lemma:widget/basicElement/addSubDialog/addSubDialog.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/basicElement/addSubDialog/addSubDialog.es_c5cb4bd.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/ui/dialog/dialog.js","wiki-lemma:widget/tools/rightCheck/rightCheck.js","wiki-lemma:widget/tools/rightCheck/checkUgc.js","wiki-common:widget/lib/jsmart/jsmart.js"]},"wiki-lemma:widget/basicElement/addSub/addSub.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/basicElement/addSub/addSub_c44287b.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-lemma:widget/basicElement/addSubDialog/addSubDialog.es.js"]},"wiki-lemma:widget/basicElement/collect/collect.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/basicElement/collect/collect_c780e5b.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/userLogin/userLogin.js","wiki-lemma:widget/tools/service/service.js"]},"wiki-lemma:widget/basicElement/commonModulePager/commonModulePager.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/basicElement/commonModulePager/commonModulePager_3be0385.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/basicElement/editorialStatement/editorialStatement.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/basicElement/editorialStatement/editorialStatement.es_1df3784.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/basicElement/modulePager/modulePager.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/basicElement/modulePager/modulePager_22cb06c.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/basicElement/personalIcon/personalIcon.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/basicElement/personalIcon/personalIcon_629c630.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/ui/dialog/dialog.js","wiki-common:widget/component/userLogin/userLogin.js","wiki-common:widget/component/nslog/nslog.js"]},"wiki-lemma:widget/basicElement/pinyin/fmp.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/basicElement/pinyin/fmp_5d69a67.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/basicElement/pinyin/lemmaPinyin.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/basicElement/pinyin/lemmaPinyin_fe030a6.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/basicElement/slidePager/slidePager.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/basicElement/slidePager/slidePager_ccf6292.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/basicElement/topShare/topShare.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/basicElement/topShare/topShare_6f18a5c.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/component/nslog/nslog.js"]},"wiki-lemma:widget/lemma_content/commonModule/album/album.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/commonModule/album/album_df5fa75.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/lemma_content/mainContent/albumList/albumList.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/albumList/albumList_0068362.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-lemma:widget/basicElement/modulePager/modulePager.js","wiki-lemma:widget/lemma_content/commonModule/album/album.js"]},"wiki-lemma:widget/lemma_content/mainContent/basicInfo/basicInfo.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/basicInfo/basicInfo_4f73206.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/lemma_content/mainContent/lemmaReference/lemmaReference.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/lemmaReference/lemmaReference_89cf4ec.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/nslog/nslog.js"]},"wiki-lemma:widget/lemma_content/mainContent/lemmaSciencePaper/lemmaSciencePaper.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/lemmaSciencePaper/lemmaSciencePaper_329480f.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/component/nslog/nslog.js"]},"wiki-lemma:widget/lemma_content/mainContent/lemmaStatistics/lemmaStatistics.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/lemmaStatistics/lemmaStatistics_76644fd.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/userCard/userCard.js"]},"wiki-lemma:widget/lemma_content/mainContent/polysemantList/polysemantList.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/polysemantList/polysemantList_232e704.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/nslog/nslog.js","wiki-lemma:widget/basicElement/addSubDialog/addSubDialog.es.js"]},"wiki-lemma:widget/lemma_content/mainContent/sideCatalog/sideCatalog.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/sideCatalog/sideCatalog_0b35785.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/nslog/nslog.js","wiki-lemma:widget/tools/throttle/throttle.es.js"]},"wiki-lemma:widget/lemma_content/mainContent/tashuo/tashuo.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/tashuo/tashuo_306d432.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/nslog/nslog.js","wiki-common:widget/component/superLogger/superLogger.es.js","wiki-lemma:widget/tools/clickstream/clickstream.js","wiki-common:widget/util/url.js"]},"wiki-lemma:widget/lemma_content/mainContent/taskLemmasInfoCard/taskLemmasInfoCard.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/taskLemmasInfoCard/taskLemmasInfoCard_d7e1b14.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js"]},"wiki-lemma:widget/lemma_content/commonModule/album/marquee.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/commonModule/album/marquee.es_9270e53.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/lemma_content/commonModule/album/albumMarquee.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/commonModule/album/albumMarquee.es_9917f07.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/commonModule/album/marquee.es.js","wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/lemma_content/commonModule/cellModule/cellModule.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/commonModule/cellModule/cellModule_e5ea8f0.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-lemma:widget/basicElement/commonModulePager/commonModulePager.js"]},"wiki-lemma:widget/lemma_content/commonModule/horizontalModule/horizontalModule.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/commonModule/horizontalModule/horizontalModule_ec4cf5c.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/lemma_content/commonModule/map/map.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/commonModule/map/map_0eec9a6.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/nslog/nslog.js"]},"wiki-lemma:widget/lemma_content/commonModule/music/musicAlbum/musicAlbum.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/commonModule/music/musicAlbum/musicAlbum_dd02264.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/lemma_content/commonModule/music/musicHot/musicHot.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/commonModule/music/musicHot/musicHot_94c575f.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/lemma_content/commonModule/musicAlbum/musicAlbumNormal/musicAlbumNormal.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/commonModule/musicAlbum/musicAlbumNormal/musicAlbumNormal_1ebf9cd.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/lemma_content/commonModule/noticeIcon/noticeIcon.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/commonModule/noticeIcon/noticeIcon_0b5e785.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/lemma_content/commonModule/publication/bookAd.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/commonModule/publication/bookAd.es_b1eb04b.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-lemma:widget/tools/clickstream/clickstream.js"]},"wiki-lemma:widget/lemma_content/commonModule/publication/publication.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/commonModule/publication/publication.es_274ab18.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-lemma:widget/lemma_content/commonModule/publication/bookAd.es.js","wiki-lemma:widget/tools/clickstream/clickstream.js"]},"wiki-lemma:widget/lemma_content/commonModule/series/series.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/commonModule/series/series_45f4280.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/promotion/baijiahao/baijiahao.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/baijiahao/baijiahao.es_be0e231.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/userLogin/userLogin.js","wiki-common:widget/lib/jsmart/jsmart.js"]},"wiki-lemma:widget/promotion/banner/banner.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/banner/banner_84eb026.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/component/superLogger/superLogger.es.js"]},"wiki-lemma:widget/promotion/bottomRecommend/bottomRecommend.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/bottomRecommend/bottomRecommend.es_9940fc8.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-lemma:widget/tools/throttle/throttle.es.js","wiki-lemma:widget/tools/clickstream/clickstream.js","wiki-lemma:widget/tools/eid/eid.es.js"]},"wiki-lemma:widget/promotion/declaration/declaration.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/declaration/declaration_3f1b3fb.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js"]},"wiki-lemma:widget/promotion/fengchao/setAdScrollEvent.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/fengchao/setAdScrollEvent_6e45515.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-lemma:widget/tools/throttle/throttle.es.js"]},"wiki-lemma:widget/promotion/fengchao/fengchao.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/fengchao/fengchao.es_f669503.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/cookie.js","wiki-common:widget/component/nslog/nslog.js","wiki-common:widget/component/testElem/testElem.js","wiki-lemma:widget/promotion/fengchao/setAdScrollEvent.js","wiki-common:widget/component/superLogger/superLogger.es.js","wiki-lemma:widget/tools/inSightDetector/inSightDetector.es.js"]},"wiki-lemma:widget/promotion/guessLike/guessLike.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/guessLike/guessLike_1424bd7.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/util/cookie.js","wiki-common:widget/component/nslog/nslog.js","wiki-lemma:widget/tools/bkclick/bkclick.js","wiki-lemma:widget/tools/inSightDetector/inSightDetector.es.js","wiki-common:widget/component/superLogger/superLogger.es.js","wiki-lemma:widget/tools/eid/eid.es.js"]},"wiki-lemma:widget/promotion/leadPVBtn/leadPVBtn.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/leadPVBtn/leadPVBtn_83981f3.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/nslog/nslog.js","wiki-common:widget/component/superLogger/superLogger.es.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-lemma:widget/tools/newSideShare/qrcode.js"]},"wiki-lemma:widget/promotion/medicalModal/medicalModal.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/medicalModal/medicalModal_b82d497.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/nslog/nslog.js"]},"wiki-lemma:widget/promotion/relatedBusiness/relatedBusiness.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/relatedBusiness/relatedBusiness_8b3e687.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/cookie.js"]},"wiki-lemma:widget/promotion/rightAd/rightAd.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/rightAd/rightAd_3285c8d.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/nslog/nslog.js","wiki-common:widget/util/cookie.js"]},"wiki-lemma:widget/promotion/rightBigAd/rightBigAd.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/rightBigAd/rightBigAd_02b11c7.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/promotion/rightGuessLike/rightGuessLike.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/rightGuessLike/rightGuessLike_b33053e.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/util/cookie.js","wiki-common:widget/component/nslog/nslog.js","wiki-lemma:widget/tools/bkclick/bkclick.js"]},"wiki-lemma:widget/promotion/rightPreciseAd/rightPreciseAd.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/rightPreciseAd/rightPreciseAd_05925e3.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/promotion/rightTashuo/rightTashuo.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/rightTashuo/rightTashuo_d5b70ac.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/nslog/nslog.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/ui/carousel/carousel.js","wiki-common:widget/ui/pager/horPager/horPager.js","wiki-lemma:widget/tools/inSightDetector/inSightDetector.es.js","wiki-lemma:widget/tools/clickstream/clickstream.js","wiki-common:widget/util/url.js"]},"wiki-lemma:widget/promotion/serviceProduct/serviceProduct.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/serviceProduct/serviceProduct.es_70e9681.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-lemma:widget/tools/clickstream/clickstream.js","wiki-lemma:widget/tools/throttle/throttle.es.js"]},"wiki-lemma:widget/promotion/slide/slide.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/slide/slide_026efef.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/ui/pager/horPager/horPager.js","wiki-common:widget/ui/carousel/carousel.js"]},"wiki-lemma:widget/promotion/topAd/topAd.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/topAd/topAd_bb7cc8d.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/component/nslog/nslog.js"]},"wiki-lemma:widget/promotion/unionAd/unionAd.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/unionAd/unionAd_083a044.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-lemma:widget/tools/inSightDetector/inSightDetector.es.js","wiki-lemma:widget/tools/bkclick/bkclick.js","wiki-common:widget/component/superLogger/superLogger.es.js","wiki-lemma:widget/promotion/fengchao/setAdScrollEvent.js"]},"wiki-lemma:widget/promotion/unionAdFromPs/unionAdFromPs.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/unionAdFromPs/unionAdFromPs_612dac5.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/promotion/vbaike/vbaike.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/promotion/vbaike/vbaike_54249ef.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/ui/pager/horPager/horPager.js","wiki-common:widget/ui/carousel/carousel.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/extendedJsmart.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/extendedJsmart_d8cbcd6.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jsmart/jsmart.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/formatListFun.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/formatListFun_08b7b48.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/logMap.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/logMap_0813299.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/dom.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/dom_717775e.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/class.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/class_cafca1f.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/helper.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/helper_23028b9.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/class.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/dom.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/default-setting.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/default-setting_01d8d6b.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/event-manager.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/event-manager_2727a1b.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/guid.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/guid_6bbbaea.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances_7dddc6d.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/class.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/dom.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/default-setting.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/event-manager.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/guid.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/helper.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/destroy.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/destroy_6959de6.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/dom.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/helper.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-scroll.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-scroll_b7a6463.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-geometry.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-geometry_a7673c0.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/class.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/dom.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/helper.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/click-rail.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/click-rail_3eff27a.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/helper.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/drag-scrollbar.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/drag-scrollbar_324e0f2.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/dom.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/helper.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/keyboard.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/keyboard_1180272.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/helper.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/dom.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/mouse-wheel.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/mouse-wheel_53033c9.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/native-scroll.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/native-scroll_3c4108d.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-geometry.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/selection.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/selection_aaa3a54.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/helper.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/touch.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/touch_75a2a8d.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/initialize.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/initialize_58cc36f.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/class.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/helper.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/click-rail.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/drag-scrollbar.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/keyboard.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/mouse-wheel.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/native-scroll.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/selection.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/handler/touch.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update_c58a304.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/dom.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/lib/helper.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-geometry.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update-scroll.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/main.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/main_d8498f6.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/destroy.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/initialize.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/update.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/index.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/index_0021e06.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/main.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/adaptor/global.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/adaptor/global_5fbec11.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/main.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/adaptor/jquery.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/adaptor/jquery_17ea17a.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/main.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/src/js/plugin/instances.js"]},"wiki-lemma:node_modules/clipboard/dist/clipboard.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/node_modules/clipboard/dist/clipboard_f71bb20.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/shareBubble.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/shareBubble_e66b1f8.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-common:widget/ui/bubble/bubble.js","wiki-common:widget/component/share/share.js","wiki-lemma:widget/tools/newSideShare/qrcode.js","wiki-common:widget/util/url.js","wiki-lemma:node_modules/clipboard/dist/clipboard.js"]},"wiki-lemma:node_modules/lodash.throttle/index.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/node_modules/lodash.throttle/index_688d1ce.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/secondsLog.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/secondsLog.es_26fede9.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/tools/clickstream/clickstream.js","wiki-lemma:node_modules/lodash.throttle/index.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnow/secondsKnow.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnow/secondsKnow_4797b7e.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/ui/dialog/dialog.js","wiki-common:widget/ui/videoPlayer/videoPlayer.js","wiki-common:widget/component/nslog/nslog.js","wiki-common:widget/component/superLogger/superLogger.es.js","wiki-common:widget/util/browser.js","wiki-common:widget/util/url.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/shareBubble.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/extendedJsmart.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/logMap.js","wiki-lemma:widget/tools/clickstream/clickstream.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/secondsLog.es.js","wiki-lemma:node_modules/lodash.throttle/index.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/formatListFun.js","wiki-common:widget/component/evtMsgManager/evtMsgManager.es.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/constants.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnowLarge/constants_dd9272c.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/container.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnowLarge/container.es_ffa1b87.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/url.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/secondsLog.es.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/formatListFun.js","wiki-lemma:widget/tools/clickstream/clickstream.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/windowScroll.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnowLarge/windowScroll_90ba014.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/elementDrag.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnowLarge/elementDrag_62de67c.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/feature/Audio/isCollide.js","wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/windowScroll.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/endAd.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnowLarge/endAd.es_0f88d33.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-lemma:widget/tools/throttle/throttle.es.js","wiki-lemma:widget/tools/eid/eid.es.js","wiki-lemma:widget/tools/clickstream/clickstream.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/endAdPlugin.min.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnowLarge/endAdPlugin.min_fb11777.js","pkg":"wiki-lemma:p4","deps":["wiki-common:widget/lib/larkplayer/larkplayer.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/logMap.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnowLarge/logMap_c740784.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:widget/lemma_content/configModule/secondsKnow/logMap.js"]},"wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/model.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnowLarge/model_9ac6c0b.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/secondsKnowLarge.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/secondsKnowLarge/secondsKnowLarge.es_68aff8e.js","pkg":"wiki-lemma:p4","deps":["wiki-lemma:node_modules/lodash.throttle/index.js","wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/larkplayer/larkplayer.js","wiki-common:widget/component/nslog/nslog.js","wiki-common:widget/component/superLogger/superLogger.es.js","wiki-common:widget/util/animation.js","wiki-common:widget/util/browser.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/perfect-scrollbar/index.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/extendedJsmart.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/shareBubble.js","wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/constants.js","wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/logMap.js","wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/model.js","wiki-lemma:widget/tools/clickstream/clickstream.js","wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/elementDrag.js","wiki-common:widget/util/guid.js","wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/windowScroll.js","wiki-common:widget/ui/dialog/dialog.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/secondsLog.es.js","wiki-lemma:widget/lemma_content/configModule/secondsKnow/formatListFun.js","wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/endAdPlugin.min.js","wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/endAd.es.js","wiki-common:widget/component/evtMsgManager/evtMsgManager.es.js","wiki-common:widget/util/url.js"]},"wiki-lemma:node_modules/resize-observer-polyfill/dist/ResizeObserver.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/node_modules/resize-observer-polyfill/dist/ResizeObserver_d7cffe0.js","pkg":"wiki-lemma:p4"},"wiki-lemma:widget/lemma_content/mainContent/lemmaRelation/lemmaInsert.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/lemmaRelation/lemmaInsert_5e08533.js","pkg":"wiki-lemma:p5","deps":["wiki-common:widget/component/nslog/nslog.js","wiki-lemma:widget/tools/clickstream/clickstream.js"]},"wiki-lemma:widget/lemma_content/mainContent/lemmaRelation/tangram.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/mainContent/lemmaRelation/tangram_53d0149.js","pkg":"wiki-lemma:p5"},"wiki-lemma:widget/feature/Audio/audioHelper.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/feature/Audio/audioHelper.es_b95a502.js","deps":["wiki-common:widget/lib/jquery/jquery.js"]},"wiki-lemma:widget/feature/Audio/getSign.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/feature/Audio/getSign.es_6fce58a.js"},"wiki-lemma:widget/feature/Audio/ttshelper.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/feature/Audio/ttshelper.es_db6ffa7.js","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/util/guid.js","wiki-lemma:widget/feature/Audio/getSign.es.js"]},"wiki-lemma:widget/feature/Audio/Audio.es.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/feature/Audio/Audio.es_ffdb5f9.js","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-lemma:widget/feature/Audio/audioHelper.es.js","wiki-common:widget/component/evtMsgManager/evtMsgManager.es.js","wiki-lemma:widget/lemma_content/configModule/secondsKnowLarge/windowScroll.js","wiki-lemma:widget/feature/Audio/ttshelper.es.js","wiki-lemma:widget/feature/Audio/isCollide.js","wiki-lemma:widget/tools/clickstream/clickstream.js"]},"wiki-lemma:widget/feature/generalAdvert/advertActivity/advertActivity.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/feature/generalAdvert/advertActivity/advertActivity_2384b45.js","deps":["wiki-common:widget/lib/jquery/jquery.js","wiki-common:widget/lib/jsmart/jsmart.js","wiki-lemma:widget/tools/newSideShare/qrcode.js","wiki-lemma:widget/tools/clickstream/clickstream.js"]},"wiki-lemma:widget/feature/generalAdvert/advertBaseInfo/advertBaseInfo.js":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/widget/feature/generalAdvert/advertBaseInfo/advertBaseInfo_c418496.js","deps":["wiki-common:widget/lib/jquery/jquery.js"]}},"pkg":{"wiki-common:p1":{"url":"https://bkssl.bdimg.com/static/wiki-common/pkg/wiki-common-jquery-ps-link_06a911b.js"},"wiki-common:p2":{"url":"https://bkssl.bdimg.com/static/wiki-common/pkg/wiki-common-base_95a37c1.js"},"wiki-lemma:p4":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/pkg/wiki-lemma_a420c64.js"},"wiki-lemma:p5":{"url":"https://bkssl.bdimg.com/static/wiki-lemma/pkg/wiki-lemma-module-lemmaRelation_1fc4824.js"}}});</script>
//        <script type="text/javascript" src="https://bkssl.bdimg.com/static/wiki-common/pkg/wiki-common-jquery-ps-link_06a911b.js"></script>
//        <script type="text/javascript" src="https://bkssl.bdimg.com/static/wiki-common/pkg/wiki-common-base_95a37c1.js"></script>
//        <script type="text/javascript" src="https://bkssl.bdimg.com/static/wiki-lemma/pkg/wiki-lemma_a420c64.js"></script>
//        <script type="text/javascript" src="https://bkssl.bdimg.com/static/wiki-lemma/widget/feature/Audio/isCollide_e311bf7.js"></script>
//        <script type="text/javascript" src="https://bkssl.bdimg.com/static/wiki-lemma/widget/lemma_content/configModule/zhixin/zhixin_f4b3ee1.js"></script>
//        <script type="text/javascript" src="https://bkssl.bdimg.com/static/wiki-lemma/layout/lemma_81b2b8f.js"></script>
//        <script type="text/javascript" src="https://bkssl.bdimg.com/static/wiki-lemma/layout/layout_76ea466.js"></script>
//        <script type="text/javascript">!function(){        require.async(['wiki-lemma:widget/tools/clickstream/clickstream']);
//        }();
//        !function(){  var $ = require('wiki-common:widget/lib/jquery/jquery'),
//        userbar = require('wiki-common:widget/component/userbar-n/userbar-n');
//
//        userbar.buildUserbar($('#j-wgt-userbar'), null);
//        }();
//        !function(){  require('wiki-common:widget/component/headTabBar/headTabBar');
//        }();
//        !function(){    var $ = require('wiki-common:widget/lib/jquery/jquery'),
//        initSearchbar = require('wiki-common:widget/component/searchbar-n/searchbar');
//        initSearchbar($('.wgt-searchbar-main'));
//        }();
//        !function(){    var $ = require('wiki-common:widget/lib/jquery/jquery');
//        var cookie = require('wiki-common:widget/util/cookie');
//        if (!cookie.get('baikedeclare')) {
//        $('#J-declare-wrap').css('display', 'block');
//        }
//        $('#J-declare-close').on('click', function () {
//        // 用户关闭后，不再显示，这里暂设过期时间为1年
//        cookie.set('baikedeclare', 'showed', {
//        expires: 365 * 60 * 60 * 24 * 1000,
//        path: '/'
//        });
//        $('#J-declare-wrap').css('display', 'none');
//        });
//        }();
//        !function(){var cookie = require('wiki-common:widget/util/cookie');
//        var $ = require('wiki-common:widget/lib/jquery/jquery');
//        var clickstream = require('wiki-common:widget/tools/clickstream/clickstream');
//
//        var timer = '';
//        var requestTime= null;
//        var currentTime= new Date().getTime();
//        $('.wgt-navbar').on('mouseenter', 'dl', function() {
//        clearTimeout(timer);
//        timer = setTimeout(function() {
//        $('.wgt-navbar').addClass('wgt-navbar-hover');
//        clickstream.logActEvent({
//        page: 'common',
//        act_type: 'hover',
//        element: 'navbar-hover'
//        });
//        }, 300);
//        }).on('mouseleave', function() {
//        clearTimeout(timer);
//        $('.wgt-navbar').removeClass('wgt-navbar-hover');
//        }).on('click', 'a', function() {
//        clearTimeout(timer);
//        $('.wgt-navbar').removeClass('wgt-navbar-hover');
//        });
//// 30分钟后更新json文件参数，防止浏览器的缓存（仅用当前时间戳会导致带宽压力过大）
//        if (!cookie.get('zhishiTopicRequestTime') || (currentTime - cookie.get('zhishiTopicRequestTime') > 1800000)) {
//        cookie.set('zhishiTopicRequestTime', currentTime);
//        requestTime = currentTime;
//        } else {
//        requestTime = cookie.get('zhishiTopicRequestTime');
//        }
//        $.getJSON('https://baikebcs.cdn.bcebos.com/cms/pc_index/knowledge_topic_menu.json?time='+ requestTime, function(data) {
//        for (var i = 0; i < data.length; i++) {
//        $('#J-knowledge-content').append('<div><a href="https://baike.baidu.com/wapui/subpage/knowledgetopic?id=' + data[i].itemId + '" target="_blank">' + data[i].title + '</a></div>')
//        }
//        })
//        }();
//        !function(){                var $ = require('wiki-common:widget/lib/jquery/jquery');
//        var rightCheck = require('wiki-lemma:widget/tools/rightCheck/rightCheck');
//
//        // 展现策略
//        rightCheck.editView('9012509', function(res) {
//        if (!res.errno) {
//        if (res.data.edit) {
//        $('.lemmaWgt-lemmaTitle .add-subLemma').css('display', 'inline-block');
//        $('.top-tool .add-sub-icon').css('display', 'inline-block');
//        }
//        } else {
//        if ('1') {
//        $('.lemmaWgt-lemmaTitle .add-subLemma').css('display', 'inline-block');
//        $('.top-tool .add-sub-icon').css('display', 'inline-block');
//        }
//        }
//        });
//        require('wiki-lemma:widget/basicElement/addSub/addSub.js')({                    lemmaId: '9012509',                    lemmaTitle:"jsoup",                    lemmaDesc:null,                    versionId: '172006724',                    subLemmaId: '4066913',                    lemmaDesc:"jsoup"
//        });
//        }();
//        !function(){        var $ = require('wiki-common:widget/lib/jquery/jquery');
//        var rightCheck = require('wiki-lemma:widget/tools/rightCheck/rightCheck');
//
//        // 展现策略
//        rightCheck.editView('9012509', function(res) {
//        if (!res.errno) {
//        if (res.data.divide) {
//        $('.top-tool .split-icon').css('display', 'block');
//        }
//        }
//        });
//        }();
//        !function(){    var nslog = require('wiki-common:widget/component/nslog/nslog');
//        require.async(["wiki-lemma:widget/basicElement/collect/collect"],function(collect){
//        collect({
//        newLemmaId:"9012509",
//        lemmaId:"4066913",
//        subLemmaId:"4066913"
//        });
//        });
//        }();
//        !function(){    require.async(["wiki-lemma:widget/basicElement/topShare/topShare"],function(topShare){
//        topShare({
//        newLemmaId: '9012509'
//        });
//        });
//        }();
//        !function(){    var $ = require('wiki-common:widget/lib/jquery/jquery');
//        var rightCheck = require('wiki-lemma:widget/tools/rightCheck/rightCheck');
//        var nsLog = require('wiki-common:widget/component/nslog/nslog');
//        var Dialog = require("wiki-common:widget/ui/dialog/dialog");
//        var clickstream = require('wiki-lemma:widget/tools/clickstream/clickstream');
//        // 展现策略
//        rightCheck.editView('9012509', function(res) {
//        if (!res.errno) {
//        if (res.data.edit) {
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'edit_btn',
//        });
//        $('.lemmaWgt-lemmaTitle .edit-lemma').css('display', 'inline-block');
//        // 编辑和申请本人实名验证保证同一行展示
//        if ($('.lemmaWgt-lemmaTitle .personal').length > 0) {
//        if ($('.lemmaWgt-lemmaTitle .edit-lemma').offset().left > $('.lemmaWgt-lemmaTitle .personal').offset().left) {
//        $('.lemmaWgt-lemmaTitle .edit-lemma').before('<br/><br/>');
//        }
//        }
//        } else {
//        nsLog('10003104');
//        $('.lemmaWgt-lemmaTitle .lock-lemma').show();
//        // 锁定和申请本人实名验证保证同一行展示
//        if ($('.lemmaWgt-lemmaTitle .personal').length > 0) {
//        if ($('.lemmaWgt-lemmaTitle .lock-lemma').offset().left > $('.lemmaWgt-lemmaTitle .personal').offset().left) {
//        $('.lemmaWgt-lemmaTitle .lock-lemma').before('<br/><br/>');
//        }
//        }
//        }
//        } else {
//        if ('1') {
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'edit_btn',
//        });
//        $('.lemmaWgt-lemmaTitle .edit-lemma').css('display', 'inline-block');
//        // 编辑和申请本人实名验证保证同一行展示
//        if ($('.lemmaWgt-lemmaTitle .personal').length > 0) {
//        if ($('.lemmaWgt-lemmaTitle .edit-lemma').offset().left > $('.lemmaWgt-lemmaTitle .personal').offset().left) {
//        $('.lemmaWgt-lemmaTitle .edit-lemma').before('<br/><br/>');
//        }
//        }
//        } else {
//        nsLog('10003104');
//        $('.lemmaWgt-lemmaTitle .lock-lemma').show();
//        // 锁定和申请本人实名验证保证同一行展示
//        if ($('.lemmaWgt-lemmaTitle .personal').length > 0) {
//        if ($('.lemmaWgt-lemmaTitle .lock-lemma').offset().left > $('.lemmaWgt-lemmaTitle .personal').offset().left) {
//        $('.lemmaWgt-lemmaTitle .lock-lemma').before('<br/><br/>');
//        }
//        }
//        }
//        }
//        });
//
//        var canDiscussion = $('.j-discussion-link').length > 0 ? true : false;
//        if (canDiscussion) {
//        var discussionKey = 'discussion' + 9012509;
//        var discussionNum = 0;
//        // 锁定跳转
//        $('body').on('click', '.lock-lemma', function () {
//        var me = $(this);
//        var content = '<div style="text-align: left;width: 528px">'
//        + '<h2 style="font-size: 20px;color: #333;line-height: 26px;margin-bottom: 20px;">'
//        + '词条锁定，暂时无法编辑</h2>'
//        + '<p style="font-size: 16px;color: #333;line-height: 26px;">'
//        + '亲爱的用户，词条存在争议或词条内容较完善都可能被锁定（'
//        + '<a href="/view/10812319.htm" target="_blank">查看详情</a>）。</p>'
//        + '<p style="font-size: 16px;color: #333;line-height: 26px;">'
//        + '如果你认为锁定词条内容存在问题需要修改，可进行以下操作：</p></div>';
//        new Dialog({
//        title: '编辑提示',
//        content: content,
//        btns: [
//        {
//        text: '<span style="font-size: 14px">参与词条讨论，反馈词条问题</span>',
//        key: 'discussion'
//        }
//        ],
//        onBtnClick: function(btnKey){
//        if (btnKey === 'discussion') {
//        window.location.href = '/planet/talk?lemmaId=9012509&category=1';
//        }
//        }
//        }).show();
//        });
//        // 获取讨论数
//        $.get('/discussion/api/getdiscussioncount?lemmaId=9012509', function (res) {
//        if (res && res.errno === 0 && res.data.discussionCount > 0) {
//        var lastNum = parseInt(localStorage.getItem(discussionKey)) || 0;
//        discussionNum = res.data.discussionCount;
//        var numText = (res.data.discussionCount - lastNum) <= 99 ? (res.data.discussionCount - lastNum) : '99+';
//        if (numText > 0 || numText === '99+') {
//        $('.j-discussion-link .num').text(numText).show();
//        }
//
//        }
//        });
//        $('.lemmaWgt-lemmaTitle .j-discussion-link').on('click', function () {
//        localStorage.setItem(discussionKey, discussionNum);
//        $(this).find('.num').remove();
//        });
//        // 讨论按钮展现量
//        nsLog(90000101, window.location.href, {
//        lemmaid: 9012509
//        });
//        }
//        // 他说讨论入口展现打点
//        function showTashuoDiscussion() {
//        var discussion = $('.j-discussion-link[nslog-type="90000102"]');
//        var jVars = $('#J-vars');
//        if (discussion.length === 1) {
//        var logParam = {
//        page: 'lemma',
//        element: 'tashuo-issue-list-entrance',
//        lemmaId: jVars.attr('data-lemmaid'),
//        lemmaTitle: jVars.attr('data-lemmatitle')
//        };
//        clickstream.logViewEl(logParam);
//        }
//        }
//
//        // 他说讨论入口点击打点
//        function clickTashuoDiscussion() {
//        var discussion = $('.j-discussion-link[nslog-type="90000102"]');
//        var jVars = $('#J-vars');
//        if (discussion.length === 1) {
//        discussion.on('click', function() {
//        var logParam = {
//        page: 'lemma',
//        element: 'tashuo-issue-list-entrance',
//        lemmaId: jVars.attr('data-lemmaid'),
//        lemmaTitle: jVars.attr('data-lemmatitle')
//        };
//        clickstream.logActClick(logParam);
//        })
//
//        }
//        }
//        showTashuoDiscussion();
//        clickTashuoDiscussion();
//        }();
//        !function(){    var $ = require('wiki-common:widget/lib/jquery/jquery');
//        var nsLog = require('wiki-common:widget/component/nslog/nslog');
//        lemmaId = 9012509;
//        lemmaTitle='jsoup';
//        var lemmaDesc = "jsoup";
//
//        var logMap ={
//        uploadShow: 10800000,
//        uploadClick: 10800001
//        };
//        nsLog(logMap.uploadShow, window.location.href, {
//        lemmaid: lemmaId,
//        lemmaTitle: lemmaTitle
//        });
//
//        function gotoPage(url, id) {
//        var el = document.createElement('a');
//
//        el.setAttribute('href', encodeURI(url));
//        el.setAttribute('target', '_blank');
//        el.setAttribute('id', id);
//
//        if(!document.getElementById(id)) {
//        document.body.appendChild(el);
//        }
//
//        el.click();
//        }
//
//        $('.J-add-video-link').on('click', function() {
//        nsLog(logMap.uploadClick, window.location.href, {
//        lemmaid: lemmaId,
//        lemmaTitle: lemmaTitle
//        });
//        var url = '/second/publish?lemmaId=' + lemmaId + '&from=lemma&lemmaTitle=' + lemmaTitle + '&lemmaDesc=' + lemmaDesc;
//
//        gotoPage(url, 'a_blank_tag')
//        })
//        }();
//        !function(){    var $ = require('wiki-common:widget/lib/jquery/jquery');
//        var Dialog = require("wiki-common:widget/ui/dialog/dialog");
//
//        function gotoPage(url, id) {
//        var el = document.createElement('a');
//
//        el.setAttribute('href', encodeURI(url));
//        el.setAttribute('target', '_blank');
//        el.setAttribute('id', id);
//
//        if(!document.getElementById(id)) {
//        document.body.appendChild(el);
//        }
//
//        el.click();
//        }
//
//        $('.J-add-video-dialog').on('click', function() {
//        var me = $(this);
//        var content = '<div style="text-align: left;width: 528px">'
//        + '<h2 style="font-size: 20px;color: #333;line-height: 26px;margin-bottom: 20px;">'
//        + '对不起，该词条暂不开放视频上传</h2>'
//        + '<p style="font-size: 16px;color: #ccc;line-height: 26px;">'
//        + '如有疑义，请点击左下角进行反馈</p></div>';
//        var noFlashDialog = new Dialog({
//        title: '提示',
//        content: content,
//        btns: [
//        {
//        text: '<span style="font-size: 14px">反馈问题</span>',
//        key: 'discussion'
//        },
//        {
//        text: '<span class="hide-dialog" style="font-size: 14px">返回词条</span>',
//        key: 'back'
//        }
//        ],
//        onBtnClick: function(btnKey) {
//        if (btnKey === 'discussion') {
//        window.location.href = '/feedback';
//        }
//        }
//        });
//        noFlashDialog.show();
//        $('.hide-dialog').on('click', function () {
//        noFlashDialog.hide();
//        });
//        })
//        }();
//        !function(){                var version = {"newLemmaIdEnc":"c305a5b096bdeb6edb20b6a2","lemmaId":4066913,"newLemmaId":9012509,"lemmaTitle":"jsoup","lemmaTitleOri":"jsoup","versionId":172006724,"passCount":13,"lock":0,"pinyin":null,"today":0,"helloEarth":0,"mapPanorama":null,"recenteTime":1620261282,"authors":[],"creator":{"authorId":330360747,"authorName":"javayuan920"},"latestEditor":{"editorId":2977826543,"editorName":"\u708e\u706b\u706b\u6797","contributeFlag":{"flagId":1,"name":"\u767e\u79d1\u874c\u86aa\u56e2","url":"https:\/\/baike.baidu.com\/kedou"}},"authority":null,"lemmaGrow":{"excellent":[{"uid":330360747,"uname":"javayuan920","score":1,"createTime":1334297251,"badges":{"good":0,"featured":0,"create":1,"hotspot":0},"contributeFlags":[]}],"complex":[]},"contributors":[{"uid":330360747,"uname":"javayuan920","score":1,"createTime":1334297251,"badges":{"good":0,"featured":0,"create":1,"hotspot":0},"contributeFlags":[]}],"extend":{"extendContent":{"discussion":{"showHelpEdit":1},"globalConfig":{"data":{"serviceAdLemmaCategory":[337597,337474]}},"voicePlus":{"card":["\u4e2d\u6587\u540d,jsoup\u3002\u5916\u6587\u540d,jsoup\u3002\u7c7b\u522b,HTML\u89e3\u6790\u5668\u3002\u7f16\u5199\u8bed\u8a00,Java\u3002\u7279\u70b9,\u63d0\u4f9b\u4e86\u4e00\u5957\u975e\u5e38\u7701\u529b\u7684API\u3002"],"modules":[],"specialTopic":[],"timeLine":[],"tashuo":[]},"seo":{"hreflang":{"x-default":"https:\/\/baike.baidu.com\/item\/jsoup\/9012509","zh":"https:\/\/baike.baidu.com\/item\/jsoup\/9012509","zh-Hans":"https:\/\/baike.baidu.com\/item\/jsoup\/9012509","zh-Hant":"https:\/\/baike.baidu.hk\/item\/jsoup\/9012509"},"canonical":"https:\/\/baike.baidu.com\/item\/jsoup\/9012509","title":"jsoup","keywords":["jsoup","jsoup\u5185\u5bb9\u7b80\u4ecb","jsoup\u4e3b\u8981\u529f\u80fd","jsoup\u603b\u7ed3"],"description":"jsoup \u662f\u4e00\u6b3eJava \u7684HTML\u89e3\u6790\u5668\uff0c\u53ef\u76f4\u63a5\u89e3\u6790\u67d0\u4e2aURL\u5730\u5740\u3001HTML\u6587\u672c\u5185\u5bb9\u3002\u5b83\u63d0\u4f9b\u4e86\u4e00\u5957\u975e\u5e38\u7701\u529b\u7684API\uff0c\u53ef\u901a\u8fc7DOM\uff0cCSS\u4ee5\u53ca\u7c7b\u4f3c\u4e8ejQuery\u7684\u64cd\u4f5c\u65b9\u6cd5\u6765\u53d6\u51fa\u548c\u64cd\u4f5c\u6570\u636e\u3002","image":"https:\/\/bkimg.cdn.bcebos.com\/smart\/1e30e924b899a9011fcfd12f16950a7b0208f535-bkimg-process,v_1,rw_1,rh_1,pad_1,color_ffffff?x-bce-process=image\/format,f_auto"}}},"blackwhitelocked":[],"expSubId":0,"noLemmaContent":false,"personalBtnShow":false,"personalModuleId":0,"showSelfEditGuide":false,"subLemmas":{"4066913":{"subLemmaId":4066913,"subVersionId":172006724,"subLemmaDesc":"jsoup","lemmaId":4066913,"lemmaTitle":"jsoup","lemmaContent":"<h2 index=\"1\">\u5185\u5bb9\u7b80\u4ecb<\/h2><p>jsoup \u662f\u4e00\u6b3eJava \u7684HTML\u89e3\u6790\u5668\uff0c\u53ef\u76f4\u63a5\u89e3\u6790\u67d0\u4e2aURL\u5730\u5740\u3001HTML\u6587\u672c\u5185\u5bb9\u3002\u5b83\u63d0\u4f9b\u4e86\u4e00\u5957\u975e\u5e38\u7701\u529b\u7684API\uff0c\u53ef\u901a\u8fc7DOM\uff0cCSS\u4ee5\u53ca\u7c7b\u4f3c\u4e8ejQuery\u7684\u64cd\u4f5c\u65b9\u6cd5\u6765\u53d6\u51fa\u548c\u64cd\u4f5c\u6570\u636e\u3002<\/p><h2 index=\"2\">\u4e3b\u8981\u529f\u80fd<\/h2><p>1. \u4ece\u4e00\u4e2aURL\uff0c\u6587\u4ef6\u6216\u5b57\u7b26\u4e32\u4e2d\u89e3\u6790HTML\uff1b<\/p><p>2. \u4f7f\u7528DOM\u6216CSS\u9009\u62e9\u5668\u6765\u67e5\u627e\u3001\u53d6\u51fa\u6570\u636e\uff1b<\/p><p>3. \u53ef\u64cd\u4f5c<a target=_blank href=\"\/item\/HTML%E5%85%83%E7%B4%A0\/5983313\" data-lemmaid=\"5983313\">HTML\u5143\u7d20<\/a>\u3001\u5c5e\u6027\u3001\u6587\u672c\uff1b<\/p><p>jsoup\u662f\u57fa\u4e8eMIT\u534f\u8bae\u53d1\u5e03\u7684\uff0c\u53ef\u653e\u5fc3\u4f7f\u7528\u4e8e\u5546\u4e1a\u9879\u76ee\u3002<\/p><p>jsoup \u7684\u4e3b\u8981\u7c7b\u5c42\u6b21\u7ed3\u6784\u5982\u4e0b\u6240\u793a\uff1a<\/p><p><img title=\"\" style=\"float: none; display: block; margin: 0px auto; clear: both;\" picsrc=\"6a600c338744ebf814706c9ed9f9d72a6059a709\" data-layout=\"largecenter\" width=\"473\" height=\"205\" url=\"https:\/\/bkimg.cdn.bcebos.com\/pic\/6a600c338744ebf814706c9ed9f9d72a6059a709?x-bce-process=image\/resize,m_lfit,w_250,h_250,limit_1\/format,f_auto\" compressw=\"250\" compressh=\"108\" data-mode=\"\" useredit=\"1\" \/><\/p><p>\u63a5\u4e0b\u6765\u6211\u4eec\u4e13\u95e8\u9488\u5bf9\u51e0\u79cd\u5e38\u89c1\u7684\u5e94\u7528\u573a\u666f\u4e3e\u4f8b\u8bf4\u660ejsoup \u662f\u5982\u4f55\u4f18\u96c5\u7684\u8fdb\u884cHTML \u6587\u6863\u5904\u7406\u7684\u3002<\/p><p><b>\u6587\u6863\u8f93\u5165<\/b><\/p><p>jsoup \u53ef\u4ee5\u4ece\u5305\u62ec\u5b57\u7b26\u4e32\u3001URL\u5730\u5740\u4ee5\u53ca\u672c\u5730\u6587\u4ef6\u6765\u52a0\u8f7dHTML \u6587\u6863\uff0c\u5e76\u751f\u6210Document \u5bf9\u8c61\u5b9e\u4f8b\u3002<\/p><p>\u4e0b\u9762\u662f\u76f8\u5173\u4ee3\u7801\uff1a<\/p><p>\/\/ \u76f4\u63a5\u4ece\u5b57\u7b26\u4e32\u4e2d\u8f93\u5165HTML \u6587\u6863<\/p><p>String html = \"\u5f00\u6e90\u4e2d\u56fd\u793e\u533a\"<\/p><p>+\"<\/p><p>\u8fd9\u91cc\u662fjsoup \u9879\u76ee\u7684\u76f8\u5173\u6587\u7ae0\";<\/p><p>Document doc = Jsoup.parse(html);<\/p><p>\/\/ \u4eceURL\u76f4\u63a5\u52a0\u8f7dHTML \u6587\u6863<\/p><p>Document doc =Jsoup.connect(\"\u7f51\u5740\/\").get();<\/p><p>String title = doc.title();<\/p><p>Document doc =Jsoup.connect(\"\u7f51\u5740\/\")<\/p><p>.data(\"query\", \"Java\") \/\/\u8bf7\u6c42\u53c2\u6570<\/p><p>.userAgent(\"I\u2019mjsoup\") \/\/\u8bbe\u7f6eUser-Agent<\/p><p>.cookie(\"auth\", \"token\") \/\/\u8bbe\u7f6ecookie<\/p><p>.timeout(3000) \/\/\u8bbe\u7f6e\u8fde\u63a5\u8d85\u65f6\u65f6\u95f4<\/p><p>.post(); \/\/\u4f7f\u7528POST\u65b9\u6cd5\u8bbf\u95eeURL<\/p><p>\/\/ \u4ece\u6587\u4ef6\u4e2d\u52a0\u8f7dHTML \u6587\u6863<\/p><p>File input = new File(\"D:\/test.html\");<\/p><p>Document doc = Jsoup.parse(input,\"UTF-8\",\"\u7f51\u5740\/\");<\/p><p>\u8bf7\u5927\u5bb6\u6ce8\u610f\u6700\u540e\u4e00\u79cdHTML \u6587\u6863\u8f93\u5165\u65b9\u5f0f\u4e2d\u7684parse \u7684\u7b2c\u4e09\u4e2a\u53c2\u6570\uff0c\u4e3a\u4ec0\u4e48\u9700\u8981\u5728\u8fd9\u91cc\u6307\u5b9a\u4e00\u4e2a\u7f51\u5740\u5462\uff08\u867d\u7136\u53ef\u4ee5\u4e0d\u6307\u5b9a\uff0c\u5982\u7b2c\u4e00\u79cd\u65b9\u6cd5\uff09\uff1f\u56e0\u4e3aHTML \u6587\u6863\u4e2d\u4f1a\u6709\u5f88\u591a\u4f8b\u5982\u94fe\u63a5\u3001\u56fe\u7247\u4ee5\u53ca\u6240\u5f15\u7528\u7684\u5916\u90e8\u811a\u672c\u3001css\u6587\u4ef6\u7b49\uff0c\u800c\u7b2c\u4e09\u4e2a\u540d\u4e3abaseURL \u7684\u53c2\u6570\u7684\u610f\u601d\u5c31\u662f\u5f53HTML \u6587\u6863\u4f7f\u7528<a target=_blank href=\"\/item\/%E7%9B%B8%E5%AF%B9%E8%B7%AF%E5%BE%84\">\u76f8\u5bf9\u8def\u5f84<\/a>\u65b9\u5f0f\u5f15\u7528\u5916\u90e8\u6587\u4ef6\u65f6\uff0cjsoup\u4f1a\u81ea\u52a8\u4e3a\u8fd9\u4e9bURL \u52a0\u4e0a\u4e00\u4e2a\u524d\u7f00\uff0c\u4e5f\u5c31\u662f\u8fd9\u4e2abaseURL\u3002<\/p><p>\u4f8b\u5982\u5f00\u6e90\u8f6f\u4ef6 \u4f1a\u88ab\u8f6c\u6362\u6210\u5f00\u6e90\u8f6f\u4ef6\u3002<\/p><p><b>\u89e3\u6790\u5e76\u63d0\u53d6HTML \u5143\u7d20<\/b><\/p><p>\u8fd9\u90e8\u5206\u6d89\u53ca\u4e00\u4e2aHTML \u89e3\u6790\u5668\u6700\u57fa\u672c\u7684\u529f\u80fd\uff0c\u4f46jsoup\u4f7f\u7528\u4e00\u79cd\u6709\u522b\u4e8e\u5176\u4ed6\u5f00\u6e90\u9879\u76ee\u7684\u65b9\u5f0f\u2014\u2014\u9009\u62e9\u5668\uff0c\u6211\u4eec\u5c06\u5728\u6700\u540e\u4e00\u90e8\u5206\u8be6\u7ec6\u4ecb\u7ecdjsoup\u9009\u62e9\u5668\uff0c\u672c\u8282\u4e2d\u4f60\u5c06\u770b\u5230jsoup\u662f\u5982\u4f55\u7528\u6700\u7b80\u5355\u7684\u4ee3\u7801\u5b9e\u73b0\u3002<\/p><p>\u4e0d\u8fc7jsoup\u4e5f\u63d0\u4f9b\u4e86\u4f20\u7edf\u7684DOM \u65b9\u5f0f\u7684\u5143\u7d20\u89e3\u6790\uff0c\u770b\u770b\u4e0b\u9762\u7684\u4ee3\u7801\uff1a<\/p><p>File input = new File(\"D:\/test.html\");<\/p><p>Document doc = Jsoup.parse(input, \"UTF-8\",\"\u7f51\u5740\/\");<\/p><p>Element content =doc.getElementById(\"content\");<\/p><p>Elements links = content.getElementsByTag(\"a\");<\/p><p>for (Element link : links) {<\/p><p>String linkHref =link.attr(\"href\");<\/p><p>String linkText =link.text();<\/p><p>}<\/p><p>\u4f60\u53ef\u80fd\u4f1a\u89c9\u5f97jsoup\u7684\u65b9\u6cd5\u4f3c\u66fe\u76f8\u8bc6\uff0c\u6ca1\u9519\uff0c\u50cf<a target=_blank href=\"\/item\/getElementById\">getElementById<\/a> \u548cgetElementsByTag \u65b9\u6cd5\u8ddfJavaScript \u7684\u65b9\u6cd5\u540d\u79f0\u662f\u4e00\u6837\u7684\uff0c\u529f\u80fd\u4e5f\u5b8c\u5168\u4e00\u81f4\u3002\u4f60\u53ef\u4ee5\u6839\u636e\u8282\u70b9\u540d\u79f0\u6216\u8005\u662fHTML \u5143\u7d20\u7684id \u6765\u83b7\u53d6\u5bf9\u5e94\u7684\u5143\u7d20\u6216\u8005\u5143\u7d20\u5217\u8868\u3002<\/p><p>\u4e0ehtmlparser \u9879\u76ee\u4e0d\u540c\u7684\u662f\uff0cjsoup \u5e76\u6ca1\u6709\u4e3aHTML \u5143\u7d20\u5b9a\u4e49\u4e00\u4e2a\u5bf9\u5e94\u7684\u7c7b\uff0c\u4e00\u822c\u4e00\u4e2aHTML \u5143\u7d20\u7684\u7ec4\u6210\u90e8\u5206\u5305\u62ec\uff1a\u8282\u70b9\u540d\u3001\u5c5e\u6027\u548c\u6587\u672c\uff0cjsoup \u63d0\u4f9b\u7b80\u5355\u7684\u65b9\u6cd5\u4f9b\u4f60\u81ea\u5df1\u68c0\u7d22\u8fd9\u4e9b\u6570\u636e\uff0c\u8fd9\u4e5f\u662fjsoup\u4fdd\u6301\u7626\u8eab\u7684\u539f\u56e0\u3002<\/p><p>\u800c\u5728\u5143\u7d20\u68c0\u7d22\u65b9\u9762\uff0cjsoup \u7684\u9009\u62e9\u5668\u7b80\u76f4\u65e0\u6240\u4e0d\u80fd\uff0c<\/p><p>File input = new File(\"D:\\test.html\");<\/p><p>Document doc =Jsoup.parse(input,\"UTF-8\",\"\u7f51\u5740\");<\/p><p>Elements links = doc.select(\"a[href]\"); \/\/ \u5177\u6709href \u5c5e\u6027\u7684\u94fe\u63a5<\/p><p>Elements pngs = doc.select(\"img[src$=.png]\");\/\/\u6240\u6709\u5f15\u7528png\u56fe\u7247\u7684\u5143\u7d20<\/p><p>Element masthead =doc.select(\"div.masthead\").first();<\/p><p>\/\/ \u627e\u51fa\u5b9a\u4e49\u4e86class=masthead \u7684\u5143\u7d20<\/p><p>Elements resultLinks = doc.select(\"h3.r &gt;a\"); \/\/ direct a after h3<\/p><p>jsoup\u4f7f\u7528\u8ddfjQuery \u4e00\u6a21\u4e00\u6837\u7684\u9009\u62e9\u5668\u5bf9\u5143\u7d20\u8fdb\u884c\u68c0\u7d22\uff0c\u4ee5\u4e0a\u7684\u68c0\u7d22\u65b9\u6cd5\u5982\u679c\u6362\u6210\u662f\u5176\u4ed6\u7684HTML \u89e3\u91ca\u5668\uff0c\u81f3\u5c11\u90fd\u9700\u8981\u5f88\u591a\u884c\u4ee3\u7801\uff0c\u800cjsoup \u53ea\u9700\u8981\u4e00\u884c\u4ee3\u7801\u5373\u53ef\u5b8c\u6210\u3002<\/p><p>jsoup \u7684\u9009\u62e9\u5668\u8fd8\u652f\u6301<a target=_blank href=\"\/item\/%E8%A1%A8%E8%BE%BE%E5%BC%8F\">\u8868\u8fbe\u5f0f<\/a>\u529f\u80fd\uff0c\u6211\u4eec\u5c06\u5728\u6700\u540e\u4e00\u8282\u4ecb\u7ecd\u8fd9\u4e2a\u8d85\u5f3a\u7684\u9009\u62e9\u5668\u3002<\/p><p><b>\u4fee\u6539\u6570\u636e<\/b><\/p><p>\u5728\u89e3\u6790\u6587\u6863\u7684\u540c\u65f6\uff0c\u6211\u4eec\u53ef\u80fd\u4f1a\u9700\u8981\u5bf9\u6587\u6863\u4e2d\u7684\u67d0\u4e9b\u5143\u7d20\u8fdb\u884c\u4fee\u6539\uff0c\u4f8b\u5982\u6211\u4eec\u53ef\u4ee5\u4e3a\u6587\u6863\u4e2d\u7684\u6240\u6709\u56fe\u7247\u589e\u52a0\u53ef\u70b9\u51fb\u94fe\u63a5\u3001\u4fee\u6539\u94fe\u63a5\u5730\u5740\u6216\u8005\u662f\u4fee\u6539\u6587\u672c\u7b49\u3002<\/p><p>\u4e0b\u9762\u662f\u4e00\u4e9b\u7b80\u5355\u7684\u4f8b\u5b50\uff1a<\/p><p>doc.select(\"div.commentsa\").attr(\"rel\", \"nofollow\");<\/p><p>\/\/\u4e3a\u6240\u6709\u94fe\u63a5\u589e\u52a0rel=nofollow \u5c5e\u6027<\/p><p>doc.select(\"div.commentsa\").addClass(\"mylinkclass\");<\/p><p>\/\/\u4e3a\u6240\u6709\u94fe\u63a5\u589e\u52a0class=mylinkclass \u5c5e\u6027<\/p><p>doc.select(\"img\").removeAttr(\"onclick\");\/\/\u5220\u9664\u6240\u6709\u56fe\u7247\u7684onclick\u5c5e\u6027<\/p><p>doc.select(\"input[type=text]\").val(\"\");\/\/\u6e05\u7a7a\u6240\u6709\u6587\u672c\u8f93\u5165\u6846\u4e2d\u7684\u6587\u672c<\/p><p>\u9053\u7406\u5f88\u7b80\u5355\uff0c\u4f60\u53ea\u9700\u8981\u5229\u7528jsoup \u7684\u9009\u62e9\u5668\u627e\u51fa\u5143\u7d20\uff0c\u7136\u540e\u5c31\u53ef\u4ee5\u901a\u8fc7\u4ee5\u4e0a\u7684\u65b9\u6cd5\u6765\u8fdb\u884c\u4fee\u6539\uff0c\u9664\u4e86\u65e0\u6cd5\u4fee\u6539\u6807\u7b7e\u540d\u5916\uff08\u53ef\u4ee5\u5220\u9664\u540e\u518d\u63d2\u5165\u65b0\u7684\u5143\u7d20\uff09\uff0c\u5305\u62ec\u5143\u7d20\u7684\u5c5e\u6027\u548c\u6587\u672c\u90fd\u53ef\u4ee5\u4fee\u6539\u3002<\/p><p>\u4fee\u6539\u5b8c\u76f4\u63a5\u8c03\u7528Element(s) \u7684html() \u65b9\u6cd5\u5c31\u53ef\u4ee5\u83b7\u53d6\u4fee\u6539\u5b8c\u7684HTML \u6587\u6863\u3002<\/p><p><b>HTML \u6587\u6863\u6e05\u7406<\/b><\/p><p>jsoup \u5728\u63d0\u4f9b\u5f3a\u5927\u7684API \u540c\u65f6\uff0c\u4eba\u6027\u5316\u65b9\u9762\u4e5f\u505a\u5f97\u975e\u5e38\u597d\u3002\u5728\u505a\u7f51\u7ad9\u7684\u65f6\u5019\uff0c\u7ecf\u5e38\u4f1a\u63d0\u4f9b\u7528\u6237\u8bc4\u8bba\u7684\u529f\u80fd\u3002\u6709\u4e9b\u7528\u6237\u6bd4\u8f83\u6dd8\u6c14\uff0c\u4f1a\u641e\u4e00\u4e9b\u811a\u672c\u5230\u8bc4\u8bba\u5185\u5bb9\u4e2d\uff0c\u800c\u8fd9\u4e9b\u811a\u672c\u53ef\u80fd\u4f1a\u7834\u574f\u6574\u4e2a\u9875\u9762\u7684\u884c\u4e3a\uff0c\u66f4\u4e25\u91cd\u7684\u662f\u83b7\u53d6\u4e00\u4e9b\u673a\u8981\u4fe1\u606f\uff0c\u4f8b\u5982XSS \u8de8\u7ad9\u70b9\u653b\u51fb\u4e4b\u7c7b\u7684\u3002<\/p><p>jsoup \u5bf9\u8fd9\u65b9\u9762\u7684\u652f\u6301\u975e\u5e38\u5f3a\u5927\uff0c\u4f7f\u7528\u975e\u5e38\u7b80\u5355\u3002\u770b\u770b\u4e0b\u9762\u8fd9\u6bb5\u4ee3\u7801\uff1a<\/p><p>String unsafe = \"<\/p><p>\u5f00\u6e90\u4e2d\u56fd\u793e\u533a\";<\/p><p>String safe = Jsoup.clean(unsafe, Whitelist.basic());<\/p><p>\/\/ \u8f93\u51fa:<\/p><p>\/\/ <\/p><p>\u5f00\u6e90\u4e2d\u56fd\u793e\u533a<\/p><p>jsoup \u4f7f\u7528\u4e00\u4e2aWhitelist \u7c7b\u7528\u6765\u5bf9HTML \u6587\u6863\u8fdb\u884c\u8fc7\u6ee4\uff0c\u8be5\u7c7b\u63d0\u4f9b\u51e0\u4e2a\u5e38\u7528\u65b9\u6cd5\uff1a<\/p><p><img title=\"\" style=\"float: none; display: block; margin: 0px auto; clear: both;\" picsrc=\"730e0cf3d7ca7bcb0fe1cf8ebe096b63f724a8fc\" data-layout=\"largecenter\" width=\"669\" height=\"292\" url=\"https:\/\/bkimg.cdn.bcebos.com\/pic\/730e0cf3d7ca7bcb0fe1cf8ebe096b63f724a8fc?x-bce-process=image\/resize,m_lfit,w_250,h_250,limit_1\/format,f_auto\" compressw=\"250\" compressh=\"109\" data-mode=\"\" useredit=\"1\" \/><\/p><p>\u5982\u679c\u8fd9\u4e94\u4e2a\u8fc7\u6ee4\u5668\u90fd\u65e0\u6cd5\u6ee1\u8db3\u4f60\u7684\u8981\u6c42\u5462\uff0c\u4f8b\u5982\u4f60\u5141\u8bb8\u7528\u6237\u63d2\u5165flash \u52a8\u753b\uff0c\u6ca1\u5173\u7cfb\uff0cWhitelist\u63d0\u4f9b\u6269\u5c55\u529f\u80fd\uff0c\u4f8b\u5982whitelist.addTags(\"embed\",\"object\",\"param\",\"span\",\"div\");\u4e5f\u53ef\u8c03\u7528addAttributes \u4e3a\u67d0\u4e9b\u5143\u7d20\u589e\u52a0\u5c5e\u6027\u3002<\/p><p><b>jsoup \u7684\u8fc7\u4eba\u4e4b\u5904\u2014\u2014\u9009\u62e9\u5668<\/b><\/p><p>\u524d\u9762\u6211\u4eec\u5df2\u7ecf\u7b80\u5355\u7684\u4ecb\u7ecd\u4e86jsoup\u662f\u5982\u4f55\u4f7f\u7528\u9009\u62e9\u5668\u6765\u5bf9\u5143\u7d20\u8fdb\u884c\u68c0\u7d22\u7684\u3002\u672c\u8282\u6211\u4eec\u628a\u91cd\u70b9\u653e\u5728\u9009\u62e9\u5668\u672c\u8eab\u5f3a\u5927\u7684\u8bed\u6cd5\u4e0a\u3002\u4e0b\u8868\u662fjsoup\u9009\u62e9\u5668\u7684\u6240\u6709\u8bed\u6cd5\u8be6\u7ec6\u5217\u8868\u3002<\/p><p>\u57fa\u672c\u7528\u6cd5<\/p><p><img title=\"\" style=\"float: none; display: block; margin: 0px auto; clear: both;\" picsrc=\"6609c93d70cf3bc71c68c54dd100baa1cd112a22\" data-layout=\"largecenter\" width=\"674\" height=\"408\" url=\"https:\/\/bkimg.cdn.bcebos.com\/pic\/6609c93d70cf3bc71c68c54dd100baa1cd112a22?x-bce-process=image\/resize,m_lfit,w_220,h_220,limit_1\/format,f_auto\" compressw=\"220\" compressh=\"133\" data-mode=\"\" useredit=\"1\" \/><\/p><p>\u4ee5\u4e0a\u662f\u6700\u57fa\u672c\u7684\u9009\u62e9\u5668\u8bed\u6cd5\uff0c\u8fd9\u4e9b\u8bed\u6cd5\u4e5f\u53ef\u4ee5\u7ec4\u5408\u8d77\u6765\u4f7f\u7528\uff0c\u4e0b\u9762\u662fjsoup\u652f\u6301\u7684\u7ec4\u5408\u7528\u6cd5\uff1a<\/p><p><img title=\"\" style=\"float: none; display: block; margin: 0px auto; clear: both;\" picsrc=\"a71ea8d3fd1f4134e04e0ddf251f95cad1c85e11\" data-layout=\"largecenter\" width=\"671\" height=\"317\" url=\"https:\/\/bkimg.cdn.bcebos.com\/pic\/a71ea8d3fd1f4134e04e0ddf251f95cad1c85e11?x-bce-process=image\/resize,m_lfit,w_250,h_250,limit_1\/format,f_auto\" compressw=\"250\" compressh=\"118\" data-mode=\"\" useredit=\"1\" \/><\/p><p>\u9664\u4e86\u4e00\u4e9b\u57fa\u672c\u7684\u8bed\u6cd5\u4ee5\u53ca\u8fd9\u4e9b\u8bed\u6cd5\u8fdb\u884c\u7ec4\u5408\u5916\uff0cjsoup \u8fd8\u652f\u6301\u4f7f\u7528<a target=_blank href=\"\/item\/%E8%A1%A8%E8%BE%BE%E5%BC%8F\">\u8868\u8fbe\u5f0f<\/a>\u8fdb\u884c\u5143\u7d20\u8fc7\u6ee4\u9009\u62e9\u3002\u4e0b\u9762\u662fjsoup\u652f\u6301\u7684\u6240\u6709\u8868\u8fbe\u5f0f\u4e00\u89c8\u8868\uff1a<\/p><p><img title=\"\" style=\"float: none; display: block; margin: 0px auto; clear: both;\" picsrc=\"38dbb6fd5266d016a9619689972bd40735fa3512\" data-layout=\"largecenter\" width=\"671\" height=\"278\" url=\"https:\/\/bkimg.cdn.bcebos.com\/pic\/38dbb6fd5266d016a9619689972bd40735fa3512?x-bce-process=image\/resize,m_lfit,w_250,h_250,limit_1\/format,f_auto\" compressw=\"250\" compressh=\"103\" data-mode=\"\" useredit=\"1\" \/><\/p><h2 index=\"3\">\u603b\u7ed3<\/h2><p>jsoup \u7684\u57fa\u672c\u529f\u80fd\u5230\u8fd9\u91cc\u5c31\u4ecb\u7ecd\u5b8c\u6bd5\uff0c\u4f46\u7531\u4e8ejsoup \u826f\u597d\u7684\u53ef\u6269\u5c55\u6027API \u8bbe\u8ba1\uff0c\u4f60\u53ef\u4ee5\u901a\u8fc7\u9009\u62e9\u5668\u7684\u5b9a\u4e49\u6765\u5f00\u53d1\u51fa\u975e\u5e38\u5f3a\u5927\u7684HTML \u89e3\u6790\u529f\u80fd\u3002\u518d\u52a0\u4e0ajsoup \u9879\u76ee\u672c\u8eab\u7684\u5f00\u53d1\u4e5f\u975e\u5e38\u6d3b\u8dc3\uff0c\u56e0\u6b64\u5982\u679c\u4f60\u6b63\u5728\u4f7f\u7528Java \uff0c\u9700\u8981\u5bf9HTML \u8fdb\u884c\u5904\u7406\uff0c\u4e0d\u59a8\u8bd5\u8bd5\u3002<\/p>","catalog":[{"title":"\u5185\u5bb9\u7b80\u4ecb","charnum":95,"screennum":0,"level":1,"index":1,"modules":[]},{"title":"\u4e3b\u8981\u529f\u80fd","charnum":3184,"screennum":3,"level":1,"index":2,"modules":[]},{"title":"\u603b\u7ed3","charnum":128,"screennum":0,"level":1,"index":3,"modules":[]}],"reference":[],"card":{"type":25,"left":[{"key":"m25_nameC","name":"\u4e2d\u6587\u540d","value":["jsoup"],"other":[]},{"key":"m25_nameE","name":"\u5916\u6587\u540d","value":["jsoup"],"other":[]}],"right":[{"key":"m25_category","name":"\u7c7b\u522b","value":["HTML\u89e3\u6790\u5668"],"other":[]},{"key":"m25_customDefault","name":"\u7f16\u5199\u8bed\u8a00","value":["Java"],"other":[]},{"key":"m25_customDefault","name":"\u7279\u70b9","value":["\u63d0\u4f9b\u4e86\u4e00\u5957\u975e\u5e38\u7701\u529b\u7684API"],"other":[]}]},"summary":{"summaryContent":"<p>jsoup \u662f\u4e00\u6b3eJava \u7684HTML\u89e3\u6790\u5668\uff0c\u53ef\u76f4\u63a5\u89e3\u6790\u67d0\u4e2aURL\u5730\u5740\u3001HTML\u6587\u672c\u5185\u5bb9\u3002\u5b83\u63d0\u4f9b\u4e86\u4e00\u5957\u975e\u5e38\u7701\u529b\u7684API\uff0c\u53ef\u901a\u8fc7DOM\uff0cCSS\u4ee5\u53ca\u7c7b\u4f3c\u4e8ejQuery\u7684\u64cd\u4f5c\u65b9\u6cd5\u6765\u53d6\u51fa\u548c\u64cd\u4f5c\u6570\u636e\u3002<\/p>","imgSrc":"1e30e924b899a9011fcfd12f16950a7b0208f535","imgTitle":"","width":491,"height":510,"owner":"","picId":47945074515,"type":{"view":220,"albumview":200,"oriWithWater":511,"litterImage":200,"authModule":150,"view_new":209,"view_card":268},"sizes":{"220":{"url":"https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/resize,m_lfit,w_220,h_220,limit_1\/format,f_auto","width":211,"height":220,"size":220},"200":{"url":"https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/resize,m_lfit,w_200,h_200,limit_1\/format,f_auto","width":192,"height":200,"size":200},"511":{"url":"https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/watermark,image_d2F0ZXIvYmFpa2U4MA==,g_7,xp_5,yp_5\/format,f_auto","width":491,"height":510,"size":511},"150":{"url":"https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/resize,m_lfit,h_160,limit_1\/format,f_auto","width":154,"height":160,"size":150},"209":{"url":"https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/resize,m_lfit,w_209,limit_1\/format,f_auto","width":209,"height":217,"size":209},"268":{"url":"https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/resize,m_lfit,w_268,limit_1\/format,f_auto","width":268,"height":278,"size":268}},"albumId":1},"moduleContent":{"album":{"47545588":{"coverPic":{"uuid":"pc8f535","src":"1e30e924b899a9011fcfd12f16950a7b0208f535","desc":"","width":491,"height":510,"origSrc":"1e30e924b899a9011fcfd12f16950a7b0208f535"},"wapPic":null,"sharePic":null,"basic":{"modulename":"album","albumTag":"","coverpic":"1e30e924b899a9011fcfd12f16950a7b0208f535","width":491,"height":510,"desc":"\u6982\u8ff0\u56fe\u518c","flag":"abstractAlbum","url":"cover=1e30e924b899a9011fcfd12f16950a7b0208f535&count=1&desc=%E6%A6%82%E8%BF%B0%E5%9B%BE%E5%86%8C","style":"center","total":1,"wapAbsAlbumEdit":0,"moduleId":47545588,"moduleVersionId":2998969023,"moduleType":2,"picId":47945074515,"type":{"view":220,"albumview":200,"oriWithWater":511,"litterImage":200,"authModule":150,"view_new":209,"view_card":268},"sizes":{"220":{"url":"https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/resize,m_lfit,w_220,h_220,limit_1\/format,f_auto","width":211,"height":220,"size":220},"200":{"url":"https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/resize,m_lfit,w_200,h_200,limit_1\/format,f_auto","width":192,"height":200,"size":200},"511":{"url":"https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/watermark,image_d2F0ZXIvYmFpa2U4MA==,g_7,xp_5,yp_5\/format,f_auto","width":491,"height":510,"size":511},"150":{"url":"https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/resize,m_lfit,h_160,limit_1\/format,f_auto","width":154,"height":160,"size":150},"209":{"url":"https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/resize,m_lfit,w_209,limit_1\/format,f_auto","width":209,"height":217,"size":209},"268":{"url":"https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/resize,m_lfit,w_268,limit_1\/format,f_auto","width":268,"height":278,"size":268}}},"toppics":[{"uuid":"pc8f535","src":"1e30e924b899a9011fcfd12f16950a7b0208f535","desc":"","width":491,"height":510}]}}},"albums":[{"coverpic":"6a600c338744ebf814706c9ed9f9d72a6059a709","width":473,"height":205,"desc":"\u8bcd\u6761\u56fe\u7247","total":5,"coverurl":"https:\/\/bkimg.cdn.bcebos.com\/pic\/6a600c338744ebf814706c9ed9f9d72a6059a709?x-bce-process=image\/resize,m_lfit,w_235,h_235,limit_1\/format,f_auto"},{"coverpic":"1e30e924b899a9011fcfd12f16950a7b0208f535","desc":"\u6982\u8ff0\u56fe\u518c","albumTag":"","height":510,"width":491,"total":1,"coverurl":"https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/resize,m_lfit,w_235,h_235,limit_1\/format,f_auto","toppics":[{"uuid":"pc8f535","src":"1e30e924b899a9011fcfd12f16950a7b0208f535","desc":"","width":491,"height":510}],"coverPic":{"uuid":"pc8f535","src":"1e30e924b899a9011fcfd12f16950a7b0208f535","desc":"","width":491,"height":510,"origSrc":"1e30e924b899a9011fcfd12f16950a7b0208f535"},"wapPic":null,"sharePic":null}],"category":[],"tag":[],"extend":{"extendContent":{"discussion":{"showHelpEdit":1},"globalConfig":{"data":{"serviceAdLemmaCategory":[337597,337474]}},"voicePlus":{"card":["\u4e2d\u6587\u540d,jsoup\u3002\u5916\u6587\u540d,jsoup\u3002\u7c7b\u522b,HTML\u89e3\u6790\u5668\u3002\u7f16\u5199\u8bed\u8a00,Java\u3002\u7279\u70b9,\u63d0\u4f9b\u4e86\u4e00\u5957\u975e\u5e38\u7701\u529b\u7684API\u3002"],"modules":[],"specialTopic":[],"timeLine":[],"tashuo":[]},"seo":{"hreflang":{"x-default":"https:\/\/baike.baidu.com\/item\/jsoup\/9012509","zh":"https:\/\/baike.baidu.com\/item\/jsoup\/9012509","zh-Hans":"https:\/\/baike.baidu.com\/item\/jsoup\/9012509","zh-Hant":"https:\/\/baike.baidu.hk\/item\/jsoup\/9012509"},"canonical":"https:\/\/baike.baidu.com\/item\/jsoup\/9012509","title":"jsoup","keywords":["jsoup","jsoup\u5185\u5bb9\u7b80\u4ecb","jsoup\u4e3b\u8981\u529f\u80fd","jsoup\u603b\u7ed3"],"description":"jsoup \u662f\u4e00\u6b3eJava \u7684HTML\u89e3\u6790\u5668\uff0c\u53ef\u76f4\u63a5\u89e3\u6790\u67d0\u4e2aURL\u5730\u5740\u3001HTML\u6587\u672c\u5185\u5bb9\u3002\u5b83\u63d0\u4f9b\u4e86\u4e00\u5957\u975e\u5e38\u7701\u529b\u7684API\uff0c\u53ef\u901a\u8fc7DOM\uff0cCSS\u4ee5\u53ca\u7c7b\u4f3c\u4e8ejQuery\u7684\u64cd\u4f5c\u65b9\u6cd5\u6765\u53d6\u51fa\u548c\u64cd\u4f5c\u6570\u636e\u3002","image":"https:\/\/bkimg.cdn.bcebos.com\/smart\/1e30e924b899a9011fcfd12f16950a7b0208f535-bkimg-process,v_1,rw_1,rh_1,pad_1,color_ffffff?x-bce-process=image\/format,f_auto"}}},"relation":{"entryAndTemList":{"top":[],"foot":[]}},"excellentInfo":{"isExcellent":false,"managers":null},"tips":[]}},"subLemmaDescs":[{"subLemmaId":4066913,"subLemmaDesc":"jsoup"}],"summary":"jsoup \u662f\u4e00\u6b3eJava \u7684HTML\u89e3\u6790\u5668\uff0c\u53ef\u76f4\u63a5\u89e3\u6790\u67d0\u4e2aURL\u5730\u5740\u3001HTML\u6587\u672c\u5185\u5bb9\u3002\u5b83\u63d0\u4f9b\u4e86\u4e00\u5957\u975e\u5e38\u7701\u529b\u7684API\uff0c\u53ef\u901a\u8fc7DOM\uff0cCSS\u4ee5\u53ca\u7c7b\u4f3c\u4e8ejQuery\u7684\u64cd\u4f5c\u65b9\u6cd5\u6765\u53d6\u51fa\u548c\u64cd\u4f5c\u6570\u636e\u3002","firstPic":"","extData":{"pass_count":13,"lemma_id":4066913,"discussion":{"relateInfo":[{"relateId":32990,"relateType":1}]},"isBaikeV6":1,"newEditor":1,"kpdClassify":[{"id":337597,"name":"\u5176\u4ed6"}],"relation":{"top":[],"foot":[]}}};
//        var cardVersionType = 25;
//        var hideVideoUpload = null
//        var classify = {
//        adManager: null,
//        kpdClassify: [{"id":337597,"name":"\u5176\u4ed6"}],
//        memorial: null
//        };
//        require.async(["wiki-common:widget/lib/jquery/jquery"],function($){
//        $.ajax({
//        url: '/api/wikiui/allowuploadvideo',
//        data: {classify: JSON.stringify(classify)},
//        success: function (res) {
//        if (res.data.allow &&
//        !(
//        (version.extend.extendContent.pinzhuan && version.extend.extendContent.pinzhuan.length) ||
//        (version.extend.extendContent.brandStory && version.extend.extendContent.brandStory.length) ||
//        (version.extend.extendContent.brandLoft && version.extend.extendContent.brandLoft.length) ||
//        hideVideoUpload
//        )
//        ) {
//        $('.J-add-video').css('display', 'inline-block');
//        } else if (!res.data.allow || (!hideVideoUpload)) {
//        $('.J-cannot-add-video').css('display', 'inline-block');
//        }
//        }
//        });
//        });
//        }();
//        !function(){	require('wiki-lemma:widget/lemma_content/mainContent/basicInfo/basicInfo')();
//        }();
//        !function(){    var $ = require('wiki-common:widget/lib/jquery/jquery');
//        var nslog = require('wiki-common:widget/component/nslog/nslog');
//        nslog(10002701);
//        $('.lemmaWgt-lemmaCatalog a').on('click', function () {
//        nslog(10002702);
//        });
//        }();
//        !function(){    var $ = require('wiki-common:widget/lib/jquery/jquery');
//        var rightCheck = require('wiki-lemma:widget/tools/rightCheck/rightCheck');
//
//        // 展现策略
//        rightCheck.editView('9012509', function(res) {
//        if (!res.errno) {
//        if (res.data.edit) {
//        $('.para-title .edit-icon').css('display', 'block');
//        }
//        } else {
//        if ('1') {
//        $('.para-title .edit-icon').css('display', 'block');
//        }
//        }
//        });
//        }();
//        !function(){    var $ = require('wiki-common:widget/lib/jquery/jquery');
//        var rightCheck = require('wiki-lemma:widget/tools/rightCheck/rightCheck');
//
//        // 展现策略
//        rightCheck.editView('9012509', function(res) {
//        if (!res.errno) {
//        if (res.data.edit) {
//        $('.para-title .edit-icon').css('display', 'block');
//        }
//        } else {
//        if ('1') {
//        $('.para-title .edit-icon').css('display', 'block');
//        }
//        }
//        });
//        }();
//        !function(){    var $ = require('wiki-common:widget/lib/jquery/jquery');
//        var rightCheck = require('wiki-lemma:widget/tools/rightCheck/rightCheck');
//
//        // 展现策略
//        rightCheck.editView('9012509', function(res) {
//        if (!res.errno) {
//        if (res.data.edit) {
//        $('.para-title .edit-icon').css('display', 'block');
//        }
//        } else {
//        if ('1') {
//        $('.para-title .edit-icon').css('display', 'block');
//        }
//        }
//        });
//        }();
//        !function(){    require(["wiki-lemma:widget/basicElement/editorialStatement/editorialStatement.es"], function(init) {
//        init(9012509);
//        });
//        }();
//        !function(){	require.async(["wiki-common:widget/lib/jquery/jquery","wiki-lemma:widget/lemma_content/mainContent/albumList/albumList","wiki-common:widget/component/nslog/nslog"],function($,AlbumList,nslog){
//        var list=new AlbumList({
//        newLemmaId:"9012509",
//        lemmaTitle:"jsoup",
//        lemmaId:"4066913",
//        subLemmaId:"4066913",
//        data:[{"coverpic":"6a600c338744ebf814706c9ed9f9d72a6059a709","width":473,"height":205,"desc":"\u8bcd\u6761\u56fe\u7247","total":5,"coverurl":"https:\/\/bkimg.cdn.bcebos.com\/pic\/6a600c338744ebf814706c9ed9f9d72a6059a709?x-bce-process=image\/resize,m_lfit,w_235,h_235,limit_1\/format,f_auto"},{"coverpic":"1e30e924b899a9011fcfd12f16950a7b0208f535","desc":"\u6982\u8ff0\u56fe\u518c","albumTag":"","height":510,"width":491,"total":1,"coverurl":"https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/resize,m_lfit,w_235,h_235,limit_1\/format,f_auto","toppics":[{"uuid":"pc8f535","src":"1e30e924b899a9011fcfd12f16950a7b0208f535","desc":"","width":491,"height":510}],"coverPic":{"uuid":"pc8f535","src":"1e30e924b899a9011fcfd12f16950a7b0208f535","desc":"","width":491,"height":510,"origSrc":"1e30e924b899a9011fcfd12f16950a7b0208f535"},"wapPic":null,"sharePic":null}],
//        pagetype:""
//        });
//        !!window.ScriptLazyLoad && window.ScriptLazyLoad.regist({
//        dom:$('.album-list'),
//        loadFunc:function(){
//        list.load();
//        nslog(1258);
//        },
//        distance:500
//        });
//        });
//        }();
//        !function(){        require('wiki-lemma:widget/lemma_content/configModule/zhixin/zhixin')(
//        9012509,
//        'jsoup'
//        );
//        }();
//        !function(){    require.async(["wiki-lemma:widget/lemma_content/mainContent/lemmaStatistics/lemmaStatistics"],function(init){
//        init({
//        newLemmaIdEnc:"c305a5b096bdeb6edb20b6a2"
//        });
//        });
//        }();
//        !function(){	require.async(["wiki-lemma:widget/lemma_content/mainContent/sideCatalog/sideCatalog"],function(SideCatalog){
//        new SideCatalog({
//        isMemorial: null,
//        catalog: [{"title":"\u5185\u5bb9\u7b80\u4ecb","charnum":95,"screennum":0,"level":1,"index":1,"modules":[],"length":8,"height":28,"top":0,"bottom":28},{"title":"\u4e3b\u8981\u529f\u80fd","charnum":3184,"screennum":3,"level":1,"index":2,"modules":[],"length":8,"height":28,"top":28,"bottom":56},{"title":"\u603b\u7ed3","charnum":128,"screennum":0,"level":1,"index":3,"modules":[],"length":4,"height":28,"top":56,"bottom":84}]
//        });
//        });
//        }();
//        !function(){        require.async(["wiki-lemma:widget/promotion/fengchao/fengchao.es","wiki-lemma:widget/promotion/unionAd/unionAd"], function (init, unionAd) {
//        init({
//        newLemmaId: "9012509",
//        lemmaTitle: "jsoup",
//        encodeLemmaTitle: "jsoup",
//        adManager: null
//        }, {
//        errFn: unionAd,
//        dom: $('#side_box_unionAd')
//        });
//        });
//        }();
//        !function(){    require.async(['wiki-lemma:widget/promotion/bottomRecommend/bottomRecommend.es'], function (App) {
//        new App({
//        lemmaInfo: {"newLemmaId":9012509,"lemmaId":4066913,"subLemmaId":4066913,"lemmaTitle":"jsoup","versionId":172006724,"isPolysemant":false,"isEditable":true,"isOrgLemma":false,"isPerview":false}
//        });
//        });
//        }();
//        !function(){        require.async(['wiki-lemma:widget/promotion/guessLike/guessLike'], function (app) {
//        app.init({
//        lemmaTitle: 'jsoup',
//        adManager: null,
//        eid: null
//        });
//        });
//        }();
//        !function(){    var $ = require('wiki-common:widget/lib/jquery/jquery');
//        var Dialog = require("wiki-common:widget/ui/dialog/dialog");
//        var userLogin = require('wiki-common:widget/component/userLogin/userLogin');
//        var unameFiller = require('wiki-common:widget/component/unameFiller/unameFiller');
//        var rightCheck = require('wiki-lemma:widget/tools/rightCheck/rightCheck');
//        var checkUgc = require('wiki-lemma:widget/tools/rightCheck/checkUgc');
//        var nsLog = require('wiki-common:widget/component/nslog/nslog');
//        var clickstream = require('wiki-lemma:widget/tools/clickstream/clickstream');
//
//        var isEnterprise = false;
//        var enterpriseOwnerUserId = 0;
//
//        var userId = 0;
//        var editUrl = '/editor/load/editload?lemmaTitle=' + encodeURIComponent('jsoup') + '&lemmaId=' + '9012509';
//        var pgcUrl = '/enterprise/editpgc?lemmaId=9012509';
//
//        userLogin.regist({
//        onLogin: function(user) {
//        userId = user ? user.uid : 0;
//        }
//        });
//
//        function showChoseEditDialog(pgcCallback, ugcCallback) {
//        new Dialog({
//        title: '编辑提示',
//        subMsg: '<p>您已开通企业百科服务，推荐您直接编辑“官方资料”，官方资料仅限企业百科绑定的百科账号修改，其他用户账号不可修改。</p><p>如果您想修改其他网友编辑的普通词条内容，请注意遵守百科百科编辑规则。<p>',
//        btns: [{
//        key: 'pgc',
//        text: '编辑官方资料'
//        }, {
//        style: 'white',
//        text: '修改普通词条',
//        key: 'ugc'
//        }],
//        onBtnClick: function(btnKey){
//        if (btnKey === 'pgc') {
//        pgcCallback && pgcCallback();
//        } else if (btnKey === 'ugc') {
//        ugcCallback && ugcCallback();
//        }
//        }
//        }).show();
//        }
//
//        function checkUserLegal(res) {
//        var legal = false;
//        switch (res.errno) {
//        case 100001:
//        nsLog('10003106');
//        userLogin.showLoginPop();
//        break;
//        case 100006:
//        unameFiller.show();
//        break;
//        default:
//        legal = true;
//        }
//        return legal;
//        }
//
//
//
//        $(document.body).on('click', '.j-edit-link', function () {
//        nsLog('10003100');
//        var dl = $(this).attr('data-edit-dl');
//        if (dl) {
//        var url = editUrl + '&ci=' + dl;
//        } else {
//        var url = editUrl;
//        }
//
//        rightCheck.preeditCheck(
//        {
//        lemmaId: '9012509',
//        lemmaTitle: 'jsoup',
//        lemmaDesc: 'jsoup',
//        versionId: '172006724',
//        action: '',
//        ci: dl
//        },
//        function (res) {
//        if (!checkUserLegal(res)) {
//        return;
//        }
//        if (isEnterprise && enterpriseOwnerUserId === userId) {
//        showChoseEditDialog(
//        function () {
//        location.href = pgcUrl;
//        },
//        function () {
//        checkUgc(res, '9012509', url);
//        }
//        );
//        } else {
//        checkUgc(res, '9012509', url);
//        }
//        }
//        );
//        });
//        }();
//        !function(){  require.async(["wiki-common:widget/lib/jquery/jquery","wiki-common:widget/component/footer/footer_feedback","wiki-common:widget/tools/clickstream/clickstream"], function($, feedback, clickstream){
//        // 新打点sdk
//        $('.question').on('click', 'a', function () {
//        var nslog = $(this).attr('nslog-type');
//        var type = $(this).attr('data-type');
//        if (nslog && type) {
//        clickstream.logActClick({
//        page: 'common',
//        element: 'footer-question-' + type,
//        nslog: nslog
//        });
//        }
//        });
//        feedback({el: '#J-bk-feedback-main',
//        proData: {
//        "extend_feedback_channel": null
//        }
//        });
//        feedback({el: '#J-bk-feedback-query', config: {
//        appid: 215645,
//        productLine: 20184,
//        needContactWay: true,
//        issuePlaceholder: '亲爱的百度百科用户，请在此填写您的质疑内容及原因哦～'
//        },
//        proData: {
//        "kw": $('#J-bk-feedback-query').data('lemma')
//        }
//        });
//        });
//        }();
//        !function(){    var $ = require('wiki-common:widget/lib/jquery/jquery'),
//        initSearchbar = require('wiki-common:widget/component/searchbar-n/searchbar');
//        initSearchbar($('.wgt-searchbar-simple'));
//        }();
//        !function(){    require.async(["wiki-lemma:widget/tools/searchHeader/toolButtons-n/toolButtons"],function(init){
//        init({
//        lemmaId:"4066913",
//        subLemmaId:"4066913",
//        newLemmaId:"9012509"
//        });
//        });
//        }();
//        !function(){    require('wiki-lemma:widget/tools/searchHeader/toolButtons-n/userInfo')();
//        }();
//        !function(){    var $ = require('wiki-common:widget/lib/jquery/jquery'),
//        animation = require('wiki-common:widget/util/animation'),
//        nslog = require('wiki-common:widget/component/nslog/nslog'),
//        initSearchbar = require('wiki-common:widget/component/searchbar/searchbar');
//        var isFadeIn = false,
//        isFadeOut = false;
//        var clickstream = require('wiki-lemma:widget/tools/clickstream/clickstream');
//        var fadeInAni, fadeOutAni;
//        $(window).on('scroll', function(e) {
//        var scrollTop = $(this).scrollTop();
//        if (scrollTop > 200 && !isFadeIn && $('.lemmaWgt-searchHeader').css('display') == 'none') {
//        fadeOutAni && fadeOutAni.stop();
//        fadeInAni = animation({
//        duration: 200,
//        easing: 'linear',
//        onStart: function() {
//        isFadeOut = false;
//        isFadeIn = true;
//        $('.lemmaWgt-searchHeader').css('display', 'block');
//        },
//        onStep: function(progress) {
//        $('.lemmaWgt-searchHeader').css('opacity', progress)
//        },
//        onComplete: function(progress) {
//        isFadeIn = false;
//        nslog(10010007);
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'topbar_edit'
//        });
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'topbar_discussion'
//        });
//        }
//        });
//        } else if (scrollTop <= 200 && !isFadeOut && $('.lemmaWgt-searchHeader').css('display') == 'block') {
//        fadeInAni && fadeInAni.stop();
//        fadeOutAni = animation({
//        duration: 300,
//        easing: 'linear',
//        onStart: function() {
//        $('.lemmaWgt-searchHeader #suggestion').hide();
//        isFadeIn = false;
//        isFadeOut = true;
//        },
//        onStep: function(progress) {
//        $('.lemmaWgt-searchHeader').css('opacity', 1 - progress);
//        },
//        onComplete: function(progress) {
//        isFadeOut = false;
//        $('.lemmaWgt-searchHeader').css('display', 'none');
//        }
//        });
//        }
//        });
//        }();
//        !function(){    require.async(["wiki-lemma:widget/tools/newSideShare/taskSideShare"],function(taskShare){
//        taskShare.init({
//        title: 'jsoup',
//        desc: "jsoup \u662f\u4e00\u6b3eJava \u7684HTML\u89e3\u6790\u5668\uff0c\u53ef\u76f4\u63a5\u89e3\u6790\u67d0\u4e2aURL\u5730\u5740\u3001HTML\u6587\u672c\u5185\u5bb9\u3002\u5b83\u63d0\u4f9b\u4e86\u4e00\u5957\u975e\u5e38\u7701\u529b\u7684API\uff0c\u53ef\u901a\u8fc7DOM\uff0cCSS\u4ee5\u53ca\u7c7b\u4f3c\u4e8ejQuery\u7684\u64cd\u4f5c\u65b9\u6cd5\u6765\u53d6\u51fa\u548c\u64cd\u4f5c\u6570\u636e\u3002",
//        pic: 'https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/resize,m_lfit,w_268,limit_1\/format,f_auto',
//        url: '',
//        qqPic: 'https:\/\/bkimg.cdn.bcebos.com\/pic\/1e30e924b899a9011fcfd12f16950a7b0208f535?x-bce-process=image\/resize,m_fill,w_491,h_491,align_0,limit_0\/format,f_auto',
//        newLemmaId: '9012509',
//        lemmaTitle: 'jsoup'
//        });
//        });
//        }();
//        !function(){require.async(["wiki-lemma:widget/feature/Audio/Audio.es"], function(proxyAudio) {
//        proxyAudio({
//        lemmaTitle: "jsoup",
//        lemmaId: 9012509,
//        pinyin: null,
//        catalog: [{"title":"\u5185\u5bb9\u7b80\u4ecb","charnum":95,"screennum":0,"level":1,"index":1,"modules":[],"length":8,"height":28,"top":0,"bottom":28},{"title":"\u4e3b\u8981\u529f\u80fd","charnum":3184,"screennum":3,"level":1,"index":2,"modules":[],"length":8,"height":28,"top":28,"bottom":56},{"title":"\u603b\u7ed3","charnum":128,"screennum":0,"level":1,"index":3,"modules":[],"length":4,"height":28,"top":56,"bottom":84}],
//        modulesData: {"card":["\u4e2d\u6587\u540d,jsoup\u3002\u5916\u6587\u540d,jsoup\u3002\u7c7b\u522b,HTML\u89e3\u6790\u5668\u3002\u7f16\u5199\u8bed\u8a00,Java\u3002\u7279\u70b9,\u63d0\u4f9b\u4e86\u4e00\u5957\u975e\u5e38\u7701\u529b\u7684API\u3002"],"modules":[],"specialTopic":[],"timeLine":[],"tashuo":[]}
//        });
//        });
//        }();
//        !function(){    var $ = require('wiki-common:widget/lib/jquery/jquery');
//        var nslog = require("wiki-common:widget/component/nslog/nslog");
//        var testElem = require('wiki-common:widget/component/testElem/testElem');
//        var cmsModuleLoader = require('wiki-common:widget/component/cmsModuleLoader/cmsModuleLoader');
//        var clickstream = require('wiki-lemma:widget/tools/clickstream/clickstream');
//        var urlExt = require('wiki-common:widget/util/url');
//        function requireAsync() {
//        require.async(['wiki-lemma:widget/tools/announcement/announcement']);
//        }
//
//        cmsModuleLoader('/api/wikiui/getlemmaconfig', [{
//        name: 'announcement',
//        script: 'wiki-lemma:widget/tools/announcement/announcement.js'
//        }]);
//
//        require.async(["wiki-lemma:widget/tools/lazyLoad/lazyLoad"], function(LazyLoad) {
//        new LazyLoad();
//        });
//
//        require.async(['wiki-common:widget/component/nslog/nslog','wiki-common:widget/lib/jquery/jquery','wiki-common:widget/component/superLogger/superLogger.es'], function(nslog, $, superLogger) {
//        nslog().setGlobal({
//        lemmaId: "4066913",
//        newLemmaId: "9012509",
//        subLemmaId: "4066913",
//        lemmaTitle: "jsoup"
//        });
//        function isFun(obj) {
//        return Object.prototype.toString.call(obj) === '[object Function]';
//        }
//        // 设置全局参数
//        if (clickstream.setLogGlobalParam && isFun(clickstream.setLogGlobalParam)) {
//        clickstream.setLogGlobalParam({
//        lemmaId: "4066913",
//        newLemmaId: "9012509",
//        subLemmaId: "4066913",
//        lemmaTitle: "jsoup"
//        });
//        }
//        // 词条页 pv
//        nslog(9322);
//        superLogger.sendPv('lemma_pc', {
//        lemmaTitle: "jsoup",
//        lemmaId: "9012509"
//        });
//        // 新打点sdk
//        clickstream.logViewPage({
//        page: 'lemma',
//        lemmaTitle: "jsoup",
//        lemmaId: "9012509",
//        nslog: 9322,
//        lemmaFrom: urlExt.getQuery('lemmaFrom', window.location.href) || '',
//        fromLemmaId: urlExt.getQuery('lemmaId', window.location.href) || '',
//        fromLemmaTitle: decodeURIComponent(urlExt.getQuery('lemmaTitle', window.location.href) || '')
//        });
//
//        // 词条页时长
//        var startTime = Date.now();
//        document.addEventListener('visibilitychange', function () {
//        if (document.visibilityState === 'hidden') {
//        superLogger.sendState('lemma_pc_duration', Date.now() - startTime, {
//        lemmaTitle: "jsoup",
//        lemmaId: "9012509"
//        });
//        } else {
//        startTime = Date.now();
//        }
//        });
//
//        $(window).on('beforeunload', function () {
//        // 超过一秒再打点，避免某些情况 visibilitychange 和 unload 同时触发
//        // 重复打点
//        if (Date.now() - startTime > 1000) {
//        superLogger.sendState('lemma_pc_duration', Date.now() - startTime, {
//        lemmaTitle: "jsoup",
//        lemmaId: "9012509"
//        });
//        }
//        });
//
//        // 链接点击 pv
//        var lemmaPageRegExp = new RegExp(/\/subview\/\d+|\/view\/\d+|\/item\//i);
//        $('body').on('mousedown', 'a', function() {
//        var href = $(this).attr('href');
//        if (href && href.indexOf('/') >= 0 && href.indexOf('#') !== 0) {
//        // 链接点击 pv
//        nslog(10000001);
//        superLogger.sendClk('lemma_link');
//        if (lemmaPageRegExp.test(href)) {
//        // 词条页链接点击 pv
//        nslog(10000002, window.location.href, {
//        targetTitle: $(this).text()
//        });
//        }
//        }
//        });
//
//        /****** 词条页站内流转需求统计 start ******/
//        (function () {
//        // 各种统计配置
//        var circulationLinkCfg = {
//        innerLink: [ // 内链
//        '.para',
//        '.lemmaWgt-baseInfo-simple-largeMovie',
//        '.lemmaWgt-baseInfo-simple-largeStar',
//        '.basic-info .basicInfo-block',
//        '.lemma-summary',
//        '.lemmaWgt-lemmaSummary',
//        '.view-tip-panel',
//        '.horizontal-module',
//        '.lemmaWgt-roleIntroduction',
//        '.dramaSeries .dramaSerialList',
//        '.module-music',
//        '.table-view',
//        '[log-set-param="table_view"]',
//        '.list-module',
//        '.cell-module',
//        '.baseBox .dl-baseinfo', // 配置后台字段
//        '.pvBtn-box .leadPVBtnWrapper',
//        '.drama-actor',
//        '#staffList',
//        '.starMovieAndTvplay',
//        '.main_tab:not(.main_tab-defaultTab)' // 除去词条tab外的tab
//        ],
//        relationTable: '.rs-container-foot', // 关系表
//        peopleRelation: '.star-info-block.relations, .lemmaWgt-focusAndRelation', // 人物关系（明星+普通）
//        moduleActors: '.featureBaseInfo .actors, .lemmaWgt-majorActors', // 主要演员、嘉宾、主持人
//        moduleWorks: '.featureBaseInfo .works, .large-feature .works', // 代表作品
//        moduleQuarterly: '.featureBaseInfo .po_quarterly, .mian_quarterly', // 分季介绍
//        rankStar: '.rank-list.stars-rank', // 明星榜
//        rankDrama: '.drama-rank-list', // 电视剧榜
//        specialTopic: '.special-topic', // 专题模块
//        modDetailTable: '#modDetailTable', // 关系表出图
//        chuizhitu: '.chuizhitu', // 垂直化模块
//        polysemantList: '.polysemantList-wrapper' // 义项切换
//        };
//        /****** 连接统计 ******/
//        function clickNslogFn() {
//        for (var k in circulationLinkCfg) {
//        if (k === 'innerLink') {
//        // 词条内链到词条页
//        var tempArr = circulationLinkCfg[k];
//        for (var i = 0, l = tempArr.length; i < l; i++) {
//        tempArr[i] += ' a';
//        }
//        var sSelector = tempArr.join(', ');
//
//        $('body').on('mousedown', sSelector, {key: k},function(e) {
//        var key = e.data.key;
//        var href = $(this).attr('href');
//        var tar = $(this).attr('target') || '';
//        if (href && href.indexOf('/') >= 0 && href.indexOf('#') !== 0
//        && tar === '_blank' && lemmaPageRegExp.test(href)) {
//        // 词条页普通内链点击 pv
//        nslog(10000004, null ,{division: key});
//        // 新打点sdk
//        clickstream.logActClick({
//        page: 'lemma',
//        element: 'inlink-click',
//        ivision: key,
//        nslog: 10000004,
//        toLemmaId: $(this).attr('data-lemmaid') || '',
//        toLemmaTitle: $(this).text() || ''
//        });
//        }
//        });
//        } else {
//        // 模块到词条页链接
//        $(circulationLinkCfg[k]).on('mousedown', 'a', {key: k}, function (e) {
//        var key = e.data.key;
//        var href = $(this).attr('href');
//        if (href && href.indexOf('#') !== 0 && lemmaPageRegExp.test(href)) {
//        // 词条页配置模块链接点击 pv
//        nslog(10000004, null, {division: key});
//        // 新打点sdk
//        clickstream.logActClick({
//        page: 'lemma',
//        element: 'inlink-click',
//        ivision: key,
//        nslog: 10000004
//        });
//        }
//        });
//        }
//        }
//        }
//        // 发起统计请求
//        clickNslogFn();
//
//        /****** 各模块展现量pv ******/
//        function checkModuleIsShow() {
//        var result = [];
//        for (var k in circulationLinkCfg) {
//        if (k !== 'innerLink' && k !== 'relationTable') {
//        !!$(circulationLinkCfg[k]).html() && result.push(k);
//        }
//        }
//        if (result.length > 0) {
//        nslog(10000005, null, {showModules: result.join(',')});
//        // 新打点sdk
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'module',
//        showModules: result.join(','),
//        nslog: 10000005
//        });
//        }
//        }
//        checkModuleIsShow();
//
//        })();
//        /****** 词条页站内流转需求统计 end ******/
//
//        });
//
//        // 广告接入 wikiad 统一加载
//        // log 词条页广告被拦截情况（此处 log 请求行为）
//        nslog(70000101, window.location.href, {
//        api: 'lemma-ad',
//        action: 'request'
//        });
//        var tags = [];
//        var tagsArray = [];
//        for (var key in tags) {
//        tagsArray.push(tags[key].tagName);
//        }
//        $.ajax({
//        type: 'GET',
//        url: '/api/wikiad/getsquirrels',
//        data: {
//        lemmaId: 9012509,
//        tags: tagsArray.join()
//        },
//        cache: false,
//        dataType: 'JSON',
//        success: function (res) {
//        // log 词条页广告被拦截情况（此处 log 请求成功）
//        nslog(70000101, window.location.href, {
//        api: 'lemma-ad',
//        action: 'success'
//        });
//
//        if (!res.errno) {
//        if (res.data[5]) {
//        require.async(['wiki-lemma:widget/promotion/rightPreciseAd/rightPreciseAd'], function(rightPreciseAd) {
//        rightPreciseAd(res.data[5]);
//        nslog(10002201, location.href, {
//        adId: res.data[5][0].adId,
//        adTitle: res.data[5][0].name,
//        adPos: 5
//        });
//        // 新打点sdk
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'rightPreciseAd',
//        adId: res.data[5][0].adId,
//        adTitle: res.data[5][0].name,
//        adPos: 5,
//        nslog: 10002201
//        });
//        });
//        } else if (res.data[1]) {
//        // 缅怀类词条屏蔽词条页v百科
//        require.async(['wiki-lemma:widget/promotion/vbaike/vbaike'], function(vbaike) {
//        vbaike(res.data[1]);
//        for(var i in res.data[1]) {
//        nslog(10002201, location.href, {
//        adId: res.data[1][i].adId,
//        adTitle: res.data[1][i].name,
//        adPos: 1
//        });
//        // 新打点sdk
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'vbaike',
//        adId: res.data[1][i].adId,
//        adTitle: res.data[1][i].name,
//        adPos: 1,
//        nslog: 10002201
//        });
//        }
//        });
//        }
//        // 缅怀类词条屏蔽广告
//        if (res.data[9]) {
//        require.async(['wiki-lemma:widget/promotion/rightBigAd/rightBigAd'], function(rightBigAd) {
//        rightBigAd(res.data[9]);
//        nslog(10002201, location.href, {
//        adId: res.data[9][0].adId,
//        adTitle: res.data[9][0].name,
//        adPos: 9
//        });
//        // 新打点sdk
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'rightBigAd',
//        adId: res.data[9][0].adId,
//        adTitle: res.data[9][0].name,
//        adPos: 9,
//        nslog: 10002201
//        });
//        });
//        } else if(res.data[2]) {
//        // 词条页轮播
//        require.async(['wiki-lemma:widget/promotion/slide/slide'], function(slide) {
//        slide(res.data[2]);
//        for(var i in res.data[2]) {
//        nslog(10002201, location.href, {
//        adId: res.data[2][i].adId,
//        adTitle: res.data[2][i].name,
//        adPos: 2
//        });
//        // 新打点sdk
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'slide',
//        adId: res.data[2][i].adId,
//        adTitle: res.data[2][i].name,
//        adPos: 2,
//        nslog: 10002201
//        });
//        }
//        });
//        }
//        // 词条页右上
//        if (res.data[3]) {
//        require.async(['wiki-lemma:widget/promotion/topAd/topAd'], function(topAd) {
//        topAd(res.data[3]);
//        nslog(10002201, location.href, {
//        adId: res.data[3][0].adId,
//        adTitle: res.data[3][0].name,
//        adPos: 3
//        });
//        // 新打点sdk
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'topAd',
//        adId: res.data[3][0].adId,
//        adTitle: res.data[3][0].name,
//        adPos: 3,
//        nslog: 10002201
//        });
//        });
//        }
//        // 词条页悬浮
//        if (res.data[4]) {
//        require.async(['wiki-lemma:widget/promotion/rightAd/rightAd'], function(rightAd) {
//        rightAd(res.data[4]);
//        nslog(10002201, location.href, {
//        adId: res.data[4][0].adId,
//        adTitle: res.data[4][0].name,
//        adPos: 4
//        });
//        // 新打点sdk
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'rightAd',
//        adId: res.data[4][0].adId,
//        adTitle: res.data[4][0].name,
//        adPos: 4,
//        nslog: 10002201
//        });
//        });
//        }
//        if (res.data[15]) {
//        require.async(['wiki-lemma:widget/promotion/banner/banner'], function(banner) {
//        banner(res.data[15], {
//        lemmaTitle: "jsoup",
//        lemmaId: "9012509"
//        });
//        nslog(10002201, location.href, {
//        adId: res.data[15][0].adId,
//        adTitle: res.data[15][0].name,
//        adPos: 15
//        });
//        // 新打点sdk
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'banner',
//        adId: res.data[15][0].adId,
//        adTitle: res.data[15][0].name,
//        adPos: 15,
//        nslog: 10002201
//        });
//        });
//        }
//        if (res.data[16]) {
//        require.async(['wiki-lemma:widget/promotion/declaration/declaration'], function(declaration) {
//        declaration(res.data[16]);
//        nslog(10002201, location.href, {
//        adId: res.data[16][0].adId,
//        adTitle: res.data[16][0].name,
//        adPos: 16
//        });
//        // 新打点sdk
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'declaration',
//        adId: res.data[16][0].adId,
//        adTitle: res.data[16][0].name,
//        adPos: 16,
//        nslog: 10002201
//        });
//        })
//        }
//        // 导流按钮(缅怀类词条不展现)
//        if (res.data[27]) {
//        require.async(['wiki-lemma:widget/feature/generalAdvert/advertActivity/advertActivity','wiki-lemma:widget/feature/generalAdvert/advertBaseInfo/advertBaseInfo','wiki-lemma:widget/promotion/leadPVBtn/leadPVBtn'], function(advertActivity, advertBaseInfo, leadPVBtn) {
//        if (res.data[27][0].isAdvert === '1') {
//        advertBaseInfo(true);
//        advertActivity(res.data[27], {
//        lemmaId: "4066913",
//        lemmaTitle: "jsoup"
//        });
//        // 服务导流展现量打点
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'service-redirect',
//        lemmaId: "4066913",
//        lemmaTitle: "jsoup"
//        });
//        } else {
//        advertBaseInfo(false);
//        leadPVBtn(res.data[27], {
//        newLemmaId: "9012509",
//        lemmaTitle: "jsoup"
//        });
//        nslog(10002201, location.href, {
//        adId: res.data[27][0].adId,
//        adTitle: res.data[27][0].name,
//        adPos: 27
//        });
//        // 新打点sdk
//        clickstream.logViewEl({
//        page: 'lemma',
//        element: 'leadPVBtn',
//        adId: res.data[27][0].adId,
//        adTitle: res.data[27][0].name,
//        adPos: 27,
//        nslog: 10002201
//        });
//        }
//        })
//        }
//        } else {
//        return;
//        }
//
//        setTimeout(function () {
//        var elemArr = {};
//        res.data[1] && res.data[1].length > 0 && (elemArr['lemma-vbaike-ad'] = $('.lemmaWgt-promotion-vbaike .promotion_viewport a:eq(0) img').get(0));
//        res.data[2] && res.data[2].length > 0 && (elemArr['lemma-slide-ad'] = $('.lemmaWgt-promotion-slide .promotion_viewport a:eq(0) img').get(0));
//        res.data[3] && res.data[3].length > 0 && (elemArr['lemma-navbar-ad'] = {
//        node: $('.header [nslog-type="10002202"]').get(0),
//        validations: {
//        'noBackgroundImage': function() {
//        return $('.header [nslog-type="10002202"]').css('background-image').indexOf(res.data[3][0].picUrl) < 0
//        }
//        }
//        });
//        res.data[4] && res.data[4].length > 0 && (elemArr['lemma-side-ad'] = {
//        node: $('.right-ad img').get(0),
//        validations: {
//        'noBackgroundImage': function() {
//        return $('.right-ad img').attr('src').indexOf(res.data[4][0].picUrl) < 0
//        }
//        }
//        });
//        res.data[15] && res.data[15].length > 0 && (elemArr['lemma-configModule-banner'] = $('.configModuleBanner').get(0));
//        res.data[16] && res.data[16].length > 0 && (elemArr['lemma-configModule-declaration'] = $('.lemmaWgt-declaration').get(0));
//
//        testElem.log(elemArr, 70000102);
//        // 广告点击 新打点sdk
//        $('.wiki-lemma').on('click', 'a[nslog-type="10002202"]', function () {
//        var params = JSON.parse($(this).attr('nslog-params' || {}));
//        var element = $(this).attr('ad-type') || 'promote';
//        clickstream.logActClick($.extend({
//        page: 'lemma',
//        element: element,
//        nslog: 10002202
//        }, params));
//        });
//        }, 1000);
//        },
//        error: function () {
//        // log 词条页广告被拦截情况（此处 log 请求失败）
//        nslog(70000101, window.location.href, {
//        api: 'lemma-ad',
//        action: 'error'
//        });
//        }
//        });
//
//        // 设置分享内容
//        window.BKShare.setCommon({
//        bdText: "\u3010jsoup_\u767e\u5ea6\u767e\u79d1\u3011jsoup \u662f\u4e00\u6b3eJava \u7684HTML\u89e3\u6790\u5668\uff0c\u53ef\u76f4\u63a5\u89e3\u6790\u67d0\u4e2aURL\u5730\u5740\u3001HTML\u6587\u672c\u5185\u5bb9\u3002\u5b83\u63d0\u4f9b\u4e86\u4e00\u5957\u975e\u5e38\u7701\u529b\u7684API\uff0c\u53ef\u901a\u8fc7DOM\uff0cCSS\u4ee5\u53ca\u7c7b\u4f3c\u4e8ejQuery\u7684\u64cd\u4f5c\u65b9\u6cd5\u6765\u53d6\u51fa\u548c\u64cd\u4f5c\u6570\u636e\u3002.....\uff08\u5206\u4eab\u81ea@\u767e\u5ea6\u767e\u79d1\uff09",
//        bdDesc: '',
//        bdUrl: 'http:\/\/baike.baidu.com\/item\/jsoup\/9012509',
//        bdPic: '',
//        onBeforeClick: function (){
//        $('.bdshare_dialog_box').hide();
//        }
//        });
//
//        // 底部投诉带入当前页面 url
//        var map = [1, 2, 6, 5];
//        $('.wgt-footer-main .suggestion').find('a').each(function(i) {
//        $(this).attr('href', 'http://help.baidu.com/newadd?word=jsoup' + '&&submit_link=' + encodeURIComponent(window.location.href) + '&prod_id=10&category=' + map[i]);
//        });
//
//        // 为超出预设内容的表格添加table-responsive控制
//        $('.main-content').find('table').each(function(index) {
//        var $that = $(this);
//        if ($that.width() > 790) {
//        $that.wrap('<div class="table-responsive"></div>');
//        }
//        });
//        if (!$('.reference-title').length) {
//        $('.main-content').addClass('main-content-margin');
//        }
//        }();
//        !function(){      require('wiki-common:widget/component/psLink/psLink');
//        var clickstream = require('wiki-common:widget/tools/clickstream/clickstream');
//        clickstream.logViewPage({
//        page: 'all-pc'
//        });
//        }();</script>
//        </body>
//        </html>
//
//        Process finished with exit code 0
