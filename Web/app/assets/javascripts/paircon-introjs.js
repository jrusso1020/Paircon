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
        nextIntroJS(id, 1, 'posts');
    });
}

function nextIntroJS(id, nextStep, nextPage) {
    completeIntroJS(id);
    if (Cookies.get(introjs_conference_id + '_introjs') == "true") {
        if (nextPage == "home") {
            Cookies.set(introjs_conference_id + '_introjs', false);     
        } 
        introJs().setOption('doneLabel', 'Next page').goToStepNumber(nextStep).start().oncomplete(function() {
            $("#" + nextPage).click();
        });  
    };
}

function completeIntroJS(id) {  
    $('.introjs-skipbutton').click(function () {
        Cookies.remove("introjs_checked");
        Cookies.set(id + '_introjs', false);
    });
    
    $('.introjs-overlay').click(function () {
        Cookies.remove("introjs_checked");
        Cookies.set(id + '_introjs', false);
    });
}