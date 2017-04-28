function saveOptions(e) {
  e.preventDefault();
  browser.storage.local.set({
    website: document.querySelector("#website").value,
    filter: document.querySelector("#filter").value
  });
}

function restoreOptions() {

  function setCurrentSite(result) {
    document.querySelector("#website").value = result.website || "None Selected!";
  }

  function setCurrentFilter(result) {
    document.querySelector("#filter").value = result.filter || "None Selected!";
  }

  function onError(error) {
    console.log(`Error: ${error}`);
  }

  var gettingSite= browser.storage.local.get("website");
  gettingSite.then(setCurrentSite, onError);
  var gettingFilter = browser.storage.local.get("filter");
  gettingFilter.then(setCurrentFilter, onError);
}

document.addEventListener("DOMContentLoaded", restoreOptions);
document.querySelector("form").addEventListener("submit", saveOptions);
