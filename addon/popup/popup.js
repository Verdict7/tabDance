var onReady = function(tabs){
  //Save tabs locally
  //TODO: Maybe not globally
  tabList = tabs;

	//First get all tabs from server.
	$.ajax({
    url: results.website + "tabs",
    contentType:"application/json; charset=utf-8",
    dataType: "json",
    type : "GET",
    success : function(r) {
      console.log(r);
      deleteTabs(r);
    }
  });
};

//Deletes all tabs from server and initializes merge
var deleteTabs = function(tabs){
  var timestamps = [];
  for(var i = 0; i < tabs.length; i ++){
    var isNew = true;
    for(var j = 0; j < tabList.length; j ++){
      if(tabs[i].url == tabList[j].url){
        isNew = false;
      }
    }
    if(isNew){//Open in browser
      var creating = browser.tabs.create({url: tabs[i].url, active : false});
      creating.then(function(tab){console.log("Opened new tab: " + tab.id + "!");}, function(err){console.log(err);});

    }
    timestamps.push(tabs[i].timestamp);
  }
  $.ajax({
    url: results.website + "tabs",
    contentType:"application/json; charset=utf-8",
    dataType: "html",
    type : "DELETE",
    data : JSON.stringify(timestamps),
    success : function(r) {
      addNewTabs(r);
    }
  });
}

//Adds all the new tabs
var addNewTabs = function(res){
  var data = [];
  var date = new Date();
  var buffer;
  for(var i = 0; i < tabList.length;i++){
    buffer = new Date(date.getTime() + i);
    data.push({url : tabList[i].url, timestamp : (buffer.toISOString()), position : tabList[i].index});
  }
	$.ajax({
		url:results.website + "tabs",
		type:"POST",
		data:JSON.stringify(data),
		contentType:"application/json; charset=utf-8",
		dataType:"json",
		success: function(){
      console.log("Finished Post");
      console.log();
		}
	})
}


var results;
var tabList;
var onErr = function(err){console.log("Some Err"); console.log(err); };
var onStorageReady = function(result){
  results = result;
  console.log(result);
  var text = browser.tabs.query({});
  text.then(onReady, onErr);
  if(result.website){
    var url = result.website + "tabs";
    console.log("Accessing URL: " + url);
    /*
    //Shorter version for get
    $.get(url, function(data){
      console.log("Received data");
      console.log(data);
    });
    */
  } else {
    console.log("Site is missing!");
  }
};
/*
Listen for clicks in the popup.
*/

document.addEventListener("click", (e) => {
  if (e.target.classList.contains("sync")) {
    //Test local storage for settings
    var getting = browser.storage.local.get(["website","filter"]);
    getting.then(onStorageReady, onErr);
  }
});
