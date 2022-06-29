(function(){"use strict";let sourcePlayer=null;let destPlayer=null;let isSourcePlayerCreated=false;let isDestPlayerCreated=false;let isSourcePlayerReady=false;let isDestPlayerReady=false;document.addEventListener('onLoadYouTubePlayer',onLoadYouTubePlayer);function onLoadYouTubePlayer(evt){let elm=evt.detail.elm;let parentElement=elm.parentElement;if(parentElement.classList.contains('embed-source')){sourcePlayer=createPlayer(elm,onReadySource,onStateChangeSource);}else if(parentElement.classList.contains('embed-dest')){destPlayer=createPlayer(elm,onReadyDest,onStateChangeDest);}else{createPlayer(elm);}}
function createPlayer(elm,onReadyHandler=null,onStateChangeHandler=null){let events={'onReady':evt=>evt.target.playVideo()};if(onReadyHandler!==null){events.onReady=onReadyHandler;}
if(onStateChangeHandler!==null){events.onStateChange=onStateChangeHandler;}
return new window.YT.Player(elm,{'width':elm.dataset.width,'height':elm.dataset.height,'videoId':elm.dataset.id,'playerVars':JSON.parse(elm.dataset.playerVars),'events':events,});}
function onReadySource(){isSourcePlayerCreated=true;isSourcePlayerReady=true;sourcePlayer.playVideo();}
function onReadyDest(){isDestPlayerCreated=true;isDestPlayerReady=true;destPlayer.playVideo();}
function onStateChangeSource(){onStateChange(destPlayer);}
function onStateChangeDest(){onStateChange(sourcePlayer);}
function onStateChange(nextPlayer){if(isSourcePlayerReady&&isDestPlayerReady&&sourcePlayer.getPlayerState()===window.YT.PlayerState.PLAYING&&destPlayer.getPlayerState()===window.YT.PlayerState.PLAYING){nextPlayer.pauseVideo();}}}());