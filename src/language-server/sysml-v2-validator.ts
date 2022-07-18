import { ValidationAcceptor, ValidationChecks, ValidationRegistry } from 'langium';
import { SysMLv2AstType, Element } from './generated/ast';
import type { SysMLv2Services } from './sysml-v2-module';

/**
 * Registry for validation checks.
 */
export class SysMLv2ValidationRegistry extends ValidationRegistry {
    constructor(services: SysMLv2Services) {
        super(services);
        const validator = services.validation.SysMLv2Validator;
        const checks: ValidationChecks<SysMLv2AstType> = {
            Element: validator.checkElementStartsWithCapital
            // Element: validator.checkPersonStartsWithCapital
        };
        this.register(checks, validator);
    }
}

/**
 * Implementation of custom validations.
 */
export class SysMLv2Validator {

    checkElementStartsWithCapital(element: Element, accept: ValidationAcceptor): void {
        if (element.name) {
            const firstChar = element.name.substring(0, 1);
            if (firstChar.toUpperCase() !== firstChar) {
                accept('warning', 'Person name should start with a capital.', { node: element, property: 'name' });
            }
        }
    }

}
