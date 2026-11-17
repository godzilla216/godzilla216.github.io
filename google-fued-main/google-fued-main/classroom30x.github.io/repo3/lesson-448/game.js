// Google Feud gameplay. Questions and answers are provided by googlefeud.js.
function numberWithCommas(number) {
    return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
function startGame(category) {
    $("#scorespan").text(window.gameData.score);
    window.gameData.qNumber = Math.floor(Math.random() * categories[category].length);
    while (window.gameData.playedQuestions[category].indexOf(window.gameData.qNumber) > -1) {
        window.gameData.qNumber = Math.floor(Math.random() * categories[category].length);
    }
    window.gameData.playedQuestions[category].push(window.gameData.qNumber);
    if (window.gameData.playedQuestions[category].length == categories[category].length) window.gameData.playedQuestions[category].length = 0;
    window.gameData.prompt = categories[category][window.gameData.qNumber];
    var promptKey = window.gameData.prompt.toLowerCase();
    window.gameData.googleResults = window.allanswers[promptKey];
    $("#categories").hide();
    $("#answerkey").html("<table id=\"table1\"><tr><td class=\"unanswered q1\"><div class=\"oval\">1</div></td></tr><tr><td class=\"unanswered q2\"><div class=\"oval\">2</div></td></tr><tr><td class=\"unanswered q3\"><div class=\"oval\">3</div></td></tr><tr><td class=\"unanswered q4\"><div class=\"oval\">4</div></td></tr><tr><td class=\"unanswered q5\"><div class=\"oval\">5</div></td></tr></table><table id=\"table2\"><tr><td class=\"unanswered q6\"><div class=\"oval\">6</div></td></tr><tr><td class=\"unanswered q7\"><div class=\"oval\">7</div></td></tr><tr><td class=\"unanswered q8\"><div class=\"oval\">8</div></td></tr><tr><td class=\"unanswered q9\"><div class=\"oval\">9</div></td></tr><tr><td class=\"unanswered q10\"><div class=\"oval\">10</div></td></tr></table><div style=\"clear:both;\"></div>");
    $("#queryspan").html(window.gameData.prompt);
    $("#starter").show();
    $("#rebox").focus();
}

function processGuess(guess) {
    guess = guess.toLowerCase();
    guess = guess.trim();
    if (guess.substr(0, 2) == "a ") guess = guess.substr(2);
    if (guess.substr(0, 3) == "an ") guess = guess.substr(3);
    if (guess.substr(0, 3) == "my ") guess = guess.substr(3);
    if (guess.substr(0, 3) == "of ") guess = guess.substr(3);
    if (guess.substr(0, 3) == "so ") guess = guess.substr(3);
    if (guess.substr(0, 4) == "the ") guess = guess.substr(4);
    if (guess.substr(0, 4) == "too ") guess = guess.substr(4);
    if (guess.substr(-9) == " in space") guess = guess.substr(0, guess.length - 9);
    if (guess.substr(-2) == "es") {
        guess = guess.substr(0, guess.length - 2);
    } else {
        if (guess.substr(-1) == "s") guess = guess.substr(0, guess.length - 1);
    }
    return guess;
}

function getresults() {
    if ($("#rebox").prop("disabled") || $("#rebox").val() == "") {
        return false;
    }
    var normalizedGuess = processGuess($("#rebox").val());
    $("#rebox").val("");
    $("#rebox").focus();
    var matched = false;
    for (var answerIndex = 0; answerIndex < window.gameData.googleResults.length; answerIndex++) {
        var answerMatches = false;
        if (processGuess(window.gameData.googleResults[answerIndex]) == normalizedGuess) {
            answerMatches = true;
        }
        if (answerMatches === true) {
            if ($(".q" + (answerIndex + 1)).hasClass("unanswered")) {
                window.gameData.score += (10 - answerIndex) * 1000;
                window.gameData.totalscore += (10 - answerIndex) * 1000;
                window.gameData.correct++;
            }
            $(".q" + (answerIndex + 1)).parent().addClass("answered");
            $(".q" + (answerIndex + 1)).removeClass("unanswered").addClass("preanswer").html("<div id=\"testdiv\" style=\"display:none\"><span class=\"otherthing\">" + window.gameData.googleResults[answerIndex] + "</span><span class=\"score\">" + (10 - answerIndex) + ",000</span></div>");
            $(".q" + (answerIndex + 1) + " #testdiv").show(
                "blind", {
                    direction: "horizontal",
                    easing: "easeInExpo",
                },
                1500
            );
            $("#scorespan").text(numberWithCommas(window.gameData.score));
            $("#highscorespan").text(numberWithCommas(window.gameData.totalscore));
            matched = true;
        }
    }
    if (matched == false) {
        window.gameData.wrong++;
        $("#failuresspan").text(3 - window.gameData.wrong);
        $("#failscontainer .failx").hide();
        $("#failscontainer .failx").slice(0, window.gameData.wrong).show();
        $("#failscontainer").show();
        setTimeout(function() {
            $("#failscontainer").hide();
        }, 1000);
        if (window.gameData.wrong == 3) {
            $(".preanswer").removeClass("preanswer");
            $("#failuresspan").css("color", "#FF0000");
            for (var answerIndex = 0; answerIndex < window.gameData.googleResults.length; answerIndex++) {
                $(".q" + (answerIndex + 1)).html(
                    "<span class=\"otherthing\">" +
                    window.gameData.googleResults[answerIndex] +
                    "</span><span class=\"score\">" +
                    (10 - answerIndex) +
                    ",000</span>"
                );
            }
            newRound();
        }
    }
    if (window.gameData.correct == window.gameData.googleResults.length) {
        newRound();
    }
}

function newRound() {
    $("#guessdiv").html('<span id="message" class="caties nextround">Next Round</span>');
    $("#message").prop("disabled", true);
    $("#rebox").prop("disabled", true);
    $(".nextround").on("click", function() {
        window.gameData.score = 0;
        window.gameData.correct = 0;
        window.gameData.wrong = 0;
        window.gameData.round++;
        $("#roundnumberspan").text(window.gameData.round);
        $("#failuresspan").text(3 - window.gameData.wrong);
        $("#scorespan").text(window.gameData.score);
        $("#starter").hide();
        $("#guessdiv").html("<div id=\"guess\" onClick=\"getresults()\" ></div>");
        $("#rebox").prop("disabled", false);
        $("#failuresspan").css("color", "#498bf3");
        $("#answerkey").html("<table id=\"table1\"><tr><td class=\"unanswered q1\"><div class=\"oval\">1</div></td></tr><tr><td class=\"unanswered q2\"><div class=\"oval\">2</div></td></tr><tr><td class=\"unanswered q3\"><div class=\"oval\">3</div></td></tr><tr><td class=\"unanswered q4\"><div class=\"oval\">4</div></td></tr><tr><td class=\"unanswered q5\"><div class=\"oval\">5</div></td></tr></table><table id=\"table2\"><tr><td class=\"unanswered q6\"><div class=\"oval\">6</div></td></tr><tr><td class=\"unanswered q7\"><div class=\"oval\">7</div></td></tr><tr><td class=\"unanswered q8\"><div class=\"oval\">8</div></td></tr><tr><td class=\"unanswered q9\"><div class=\"oval\">9</div></td></tr><tr><td class=\"unanswered q10\"><div class=\"oval\">10</div></td></tr></table><div style=\"clear:both;\"></div>");
        $("#categories").show();
        $(this).hide();
    });
}
jQuery(document).ready(function() {
    window.gameData = {};
    window.gameData.score = 0;
    window.gameData.totalscore = 0;
    window.gameData.correct = 0;
    window.gameData.wrong = 0;
    window.gameData.round = 1;
    window.gameData.playedQuestions = [];
    window.gameData.playedQuestions.people = [];
    window.gameData.playedQuestions.culture = [];
    window.gameData.playedQuestions.names = [];
    window.gameData.playedQuestions.questions = [];
    $(".caties").on("click", function() {
        window.gameData.cat = $(this).attr("data-cat");
        startGame($(this).attr("data-cat"));
    });
});
