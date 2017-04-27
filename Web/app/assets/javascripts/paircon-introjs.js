function initializeIntroJS(id) {
    startIntroJS(id);
    if (Cookies.get("introjs_checked") == "true") {
        if (typeof Cookies.get(id + '_introjs') === 'undefined') {
            Cookies.set(id + '_introjs', true);
        }   
    } else if (Cookies.get("introjs_checked") == "false") {
        Cookies.set(id + '_introjs', false);
    }
}

function startIntroJS(id) {
    $('#startButton').click(function () {
        Cookies.set("introjs_checked", true);
        Cookies.set(id + '_introjs', true);
        completeIntroJS(id);
        introJs().goToStepNumber(3).start();
    });
}

function nextIntroJS(id, nextStep, nextPage) {
    console.log("next_start"); 
    completeIntroJS(id);
    if (Cookies.get(introjs_conference_id + '_introjs') == "true") {
        introJs().setOption('doneLabel', 'Next page').goToStepNumber(nextStep).start().oncomplete(function() {
            $("#" + nextPage).click();
        });
        console.log("next_start_end");        
    };

    if (nextPage == "N/A") {
        Cookies.set(introjs_conference_id + '_introjs', false);   
        console.log("about");    
    }
}

function completeIntroJS(id) {
    console.log("complete 0");    
    $('.introjs-skipbutton').click(function () {
        Cookies.remove("introjs_checked");
        Cookies.set(id + '_introjs', false);
        console.log("complete 1");
    });
    
    $('.introjs-overlay').click(function () {
        Cookies.remove("introjs_checked");
        Cookies.set(id + '_introjs', false);
        console.log("complete 1");
    });
}