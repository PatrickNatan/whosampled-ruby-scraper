(function(){'use strict';const VOTE_UP=1;const VOTE_DOWN=-1;for(const elm of document.querySelectorAll('.vote')){elm.addEventListener('click',onVoteClick);}
for(const elm of document.querySelectorAll('.fs-entry-credits')){elm.addEventListener('click',onCreditsClick);}
async function onVoteClick(evt){const voteIcon=evt.currentTarget;const parentElement=voteIcon.parentElement;try{if(voteIcon.classList.contains('fs-vote-up')){await vote(parentElement,voteIcon.dataset.factId,VOTE_UP);voteIcon.classList.toggle('fs-up-voted');parentElement.querySelector('.fs-vote-down').classList.remove('fs-down-voted');}else if(voteIcon.classList.contains('fs-vote-down')){await vote(parentElement,voteIcon.dataset.factId,VOTE_DOWN);voteIcon.classList.toggle('fs-down-voted');parentElement.querySelector('.fs-vote-up').classList.remove('fs-up-voted');}}catch(error){console.error(error);}}
async function vote(node,factID,vote){const formData=new FormData();formData.append('fact_id',factID);formData.append('vote',vote);const response=await WS.sendPOST(WS.voteFactURL,formData);if('error'in response.data){throw new Error(response.data.error);}else{node.querySelector('.fs-votes-count').innerHTML=response.data.votes_count;}}
function onCreditsClick(evt){const elm=evt.currentTarget;elm.classList.toggle('collapsed');elm.nextElementSibling.classList.toggle('collapsed');}}());