var onReady = function(tabs){console.log("Test"); console.log(tabs); };
var onErr = function(err){console.log("Some Err"); console.log(err); };
var onStorageReady = function(result){console.log(result); var text = browser.tabs.query({}); text.then(onReady, onErr); };
/*
Listen for clicks in the popup.
*/

document.addEventListener("click", (e) => {
  if (e.target.classList.contains("sync")) {
    /*
    var text = browser.tabs.query({}); 
    text.then(onReady, onErr); 
    */
    //Test local storage for settings
    var getting = browser.storage.local.get(["website","filter"]); 
    getting.then(onStorageReady, onErr); 
  }
});

