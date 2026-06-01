package com.example.dl645.core.parse.dl645;

import lombok.extern.slf4j.Slf4j;

/**
 * 加载 DL/T 645-2007 DI 规则
 */
@Slf4j
final class Dl645DocRuleRegistry {

    static {
        log.info("加载DL645文档DI规则{}条(静态类)", Dl645DocRuleCatalog.size());
    }

    private Dl645DocRuleRegistry() {
    }

    static Rule get(String di) {
        if (di == null) {
            return null;
        }
        return Dl645DocRuleCatalog.get(di.toUpperCase());
    }

    static final class Rule {
        final String di;
        final String parseTypeGuess;
        final String format;

        Rule(String di, String parseTypeGuess, String format) {
            this.di = di;
            this.parseTypeGuess = parseTypeGuess;
            this.format = format;
        }
    }
}
