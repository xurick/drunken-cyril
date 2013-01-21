function mbilify_redirect(url){
  try {
    if (document.location.search.indexOf('no_redirect') < 0) {
      if ((navigator.userAgent.match(/(iPhone|iPod|BlackBerry|Android.*Mobile|webOS|Windows CE|IEMobile|Opera Mini|Opera Mobi|HTC|LG-|LGE|SAMSUNG|Samsung|SEC-SGH|Symbian|Nokia|PlayStation|PLAYSTATION|Nintendo DSi)/i)) ) {
        window.location.replace(url);
      }
    }
  }
  catch(err){}
}
