function initializeIntroJS(id) {
    startIntroJS(id);
    if (Cookies.get("introjs_checked") == "true") {
        if (typeof Cookies.get(id) === 'undefined') {
            Cookies.set(id + '_introjs', true);
        }    
        alert("initial");
        introJs().goToStepNumber(1).start();
    } else {
        alert("no intro");
        Cookies.set(id + '_introjs', false);
    }
}

function startIntroJS(id) {
    $('#startButton').click(function () {
        introJs().goToStepNumber(1).start();
        completeIntroJS(id);
    });
}

function completeIntroJS(id) {
    $('.introjs-skipbutton').click(function () {
        Cookies.set(id + '_introjs', false);
    });

    $('.introjs-overlay').click(function () {
        Cookies.set(id + '_introjs', false);
    });
}
