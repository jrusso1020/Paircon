function initializeIntroJS(id) {
    console.log("init");
    startIntroJS(id);
    if (Cookies.get("introjs_checked") == "true") {
        if (typeof Cookies.get(id + '_introjs') === 'undefined') {
            Cookies.set(id + '_introjs', true);
        }   
        if (Cookies.get(id + '_introjs') == "true") {
            introJs().goToStepNumber(2).start();        
        }
    } else if (Cookies.get("introjs_checked") == "false") {
        Cookies.set(id + '_introjs', false);
    }
}

function startIntroJS(id) {
    $('#startButton').click(function () {
        Cookies.set("introjs_checked", true);
        Cookies.set(id + '_introjs', true);
        introJs().goToStepNumber(1).start();
        console.log("start 1");
        completeIntroJS(id);
    });
}

function completeIntroJS(id) {
    $('.introjs-skipbutton').click(function () {
        Cookies.remove("introjs_checked");
        Cookies.set(id + '_introjs', false);
        console.log("leave 1");
    });
    
    $('.introjs-overlay').click(function () {
        Cookies.remove("introjs_checked");
        Cookies.set(id + '_introjs', false);
        console.log("leave 2");
    });
}