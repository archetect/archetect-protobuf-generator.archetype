let context = #{};

if type_of(ANSWERS.model) != "map" {
    log(Error, "This archetype requires a model 'map' to by supplied as an answer");
    exit();
} else {
    context += render(Archetype("model-casing"), #{
        model: ANSWERS.model,
    });
}
context.java_package = ANSWERS.java_package;
context.go_package = ANSWERS.go_package;

context += prompt("Project Prefix:", "project-prefix", #{
    cases: CasedIdentityCasedValue(PROGRAMMING_CASES),
});

context += prompt("Project Suffix:", "project-suffix", #{
    cases: CasedIdentityCasedValue(PROGRAMMING_CASES),
});

context += set("project-name", `${context["project-prefix"]}-${context["project-suffix"]}`, #{
    cases: [
        CasedIdentityCasedValue(PROGRAMMING_CASES),
        FixedKeyCasedValue("project-title", TitleCase),
    ],
});

if switch_enabled("debug-context") {
    display(as_yaml(context));
}

render(Directory("contents"), context, #{
    if_exists: Overwrite,
});
