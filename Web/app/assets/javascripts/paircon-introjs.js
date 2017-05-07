function initializeSwitchery() {
    enableSwitchery();
    $('#continue_button').click(function( ){
        var x = document.getElementById("introjs_checkbox").checked;
        if (x) {
          Cookies.set("introjs_checked", "true");
        } else {
          Cookies.set("introjs_checked", "false");
        }
       $('#form_submit').click();
    });
}


function initializeIntroJS(id) {
    if (Cookies.get("introjs_checked") == "true") {
        if (typeof Cookies.get(id + '_introjs') === 'undefined') {
            Cookies.set(id + '_introjs', true);
            Cookies.set(id + '_introjs_prev_step', false);
        }   
    }
    if (Cookies.get("introjs_checked") == "false") {
        Cookies.set(id + '_introjs', false);
        Cookies.set(id + '_introjs_prev_step', false);
    }
    startIntroJS(id);
}

function startIntroJS(id) { 
    $('#startButton').click(function () {
        Cookies.set("introjs_checked", true);
        Cookies.set(id + '_introjs', true);
        Cookies.set(id + '_introjs_prev_step', false);
        nextIntroJS(id, 1, 1, 'home', 'posts');
    });
}

function nextIntroJS(id, prevStep, nextStep, prevPage, nextPage) {
    if (Cookies.get(id + '_introjs') == "true") {
        if (nextPage == "home") {
            Cookies.set("introjs_checked", false);
            Cookies.set(id + '_introjs', false);     
        } 
        if (Cookies.get(id + '_introjs_prev_step') == "false") {
            introJs().setOption('doneLabel', 'Next page').setOption('keyboardNavigation', false).goToStepNumber(nextStep).start().oncomplete(function() {
                $("#" + nextPage).click();
            });  
        } else if (Cookies.get(id + '_introjs_prev_step') == "true") {
            Cookies.set(id + '_introjs_prev_step', false);
            introJs().setOption('doneLabel', 'Next page').setOption('keyboardNavigation', false).goToStepNumber(prevStep).start().oncomplete(function() {
                $("#" + nextPage).click();
            });  
        }
    } else {
        introJs().exit();
    }

    $('.introjs-prevbutton').click(function () {
        Cookies.set(id + '_introjs_prev_step', true);
        var xStr = document.querySelector( ".introjs-helperNumberLayer" );
        var xInt = parseInt(xStr.innerText)
        if (nextStep == xInt) {
            introJs().exit();
            $("#" + prevPage).click();
        }
    });

    $('.introjs-nextbutton').click(function () {
        var xStr = document.querySelector( ".introjs-helperNumberLayer" );
        var xInt = parseInt(xStr.innerText);
        if (xInt >= 14) {
            introJs().exit();
            $("#" + nextPage).click();
        }
    }); 
    completeIntroJS(id);  
}

function completeIntroJS(id) {  
    $('.introjs-skipbutton').click(function () {
        Cookies.set("introjs_checked", false);
        Cookies.set(id + '_introjs', false);
        introJs().exit();
    }); 
    $('.introjs-overlay').click(function () {  
        Cookies.set("introjs_checked", false);
        Cookies.set(id + '_introjs', false);
        introJs().exit();
    });
}