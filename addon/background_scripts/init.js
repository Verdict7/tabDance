//Called when tab changes
//Only handles url changes
function handleUpdated(tabId, changeInfo, tabInfo) {
  if (changeInfo.url) {
		console.log(tabInfo);
    console.log("Tab: " + tabId +
                " URL changed to " + changeInfo.url);
  }
}

browser.tabs.onUpdated.addListener(handleUpdated);

//Called when new tab is created
function handleCreated(tab) {
  console.log(tab.id);
  console.log(tab.url);
}

browser.tabs.onCreated.addListener(handleCreated);
