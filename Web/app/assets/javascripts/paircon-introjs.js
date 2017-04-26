function initializeIntroJS(id) {
    console.log("init");
    
    
    console.log("check " + Cookies.get('introjs_checked'));
    console.log("id " + Cookies.get(introjs_conference_id + '_introjs'));
    
    
    
    startIntroJS(id);


    console.log("before check");

    if (Cookies.get("introjs_checked") == "true") {
        if (typeof Cookies.get(id + '_introjs') === 'undefined') {
            Cookies.set(id + '_introjs', true);
        }   
        if (Cookies.get(id + '_introjs') == "true") {
            introJs().goToStepNumber(2).start();
                    console.log("start 2");        
        }
    } else if (Cookies.get("introjs_checked") == "false") {
        Cookies.set(id + '_introjs', false);
    }
}

function startIntroJS(id) {
    $('#startButton').click(function () {
        Cookies.set("introjs_checked", true);
        Cookies.set(id + '_introjs', true);
        introJs().goToStepNumber(3).start();
        console.log("start 3");

    });
    completeIntroJS(id);
    console.log("start 4");
}

function nextIntroJS(id, nextStep, nextPage) {
  if (Cookies.get(introjs_conference_id + '_introjs') == "true") {
    introJs().setOption('doneLabel', 'Next page').goToStepNumber(nextStep).start().oncomplete(function() {
      $("#" + nextPage).click();
    });
  };
  
  
  console.log("start 2");
  
}

function completeIntroJS(id) {
    
    console.log("complete 1");

    $('.introjs-skipbutton').click(function () {
        Cookies.remove("introjs_checked");
        Cookies.set(id + '_introjs', false);
        console.log("leave 1");
    });
    
    
    console.log("complete 2");
    
    
    $('.introjs-overlay').click(function () {
        Cookies.remove("introjs_checked");
        Cookies.set(id + '_introjs', false);
        console.log("leave 2");
    });
    
    
    console.log("complete 3");
}