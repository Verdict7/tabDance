var onReady = function(tabs){
  console.log("Test"); 
  console.log(tabs); 

  //Test Post request
  var url = results.website + "tabs";
  var data = [{ url : "facebook.com", timestamp : ((new Date()).toISOString()), position : 2}];

	$.ajax({
		url:url,
		type:"POST",
		data:JSON.stringify(data),
		contentType:"application/json; charset=utf-8",
		dataType:"json",
		success: function(){
      console.log("Finished Post"); 
      console.log(result); 
		}
	})
};

var results; 
var onErr = function(err){console.log("Some Err"); console.log(err); };
var onStorageReady = function(result){
  results = result; 
  console.log(result); 
  var text = browser.tabs.query({}); 
  text.then(onReady, onErr); 
  if(result.website){ 
    var url = result.website + "tabs";
    console.log("Accessing URL: " + url); 
    $.get(url, function(data){
      console.log("Received data"); 
      console.log(data); 
    });
  } else {
    console.log("Site is missing!"); 
  }
};
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

