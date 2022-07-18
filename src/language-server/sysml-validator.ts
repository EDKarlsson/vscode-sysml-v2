import { ValidationAcceptor, ValidationChecks, ValidationRegistry } from 'langium';
import { SysMLAstType, Element } from './generated/ast';
import type { SysMLServices } from './sysml-module';

/**
 * Registry for validation checks.
 */
export class SysMLValidationRegistry extends ValidationRegistry {
    constructor(services: SysMLServices) {
        super(services);
        const validator = services.validation.SysMLValidator;
        const checks: ValidationChecks<SysMLAstType> = {
            Element: validator.checkElementStartsWithCapital
            // Element: validator.checkPersonStartsWithCapital
        };
        this.register(checks, validator);
    }
}

/**
 * Implementation of custom validations.
 */
export class SysMLValidator {

    checkElementStartsWithCapital(element: Element, accept: ValidationAcceptor): void {
        if (element.name) {
            const firstChar = element.name.substring(0, 1);
            if (firstChar.toUpperCase() !== firstChar) {
                accept('warning', 'Element name should start with a capital.', { node: element, property: 'name' });
            }
        }
    }

}
