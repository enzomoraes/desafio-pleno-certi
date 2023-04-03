import CreateUserException from '../../users/exceptions/CreateUserException';
import { CreateUserValidatorPipe } from './create-user-validator.pipe';

describe('CreateUserValidatorPipe', () => {
  it('should be defined', () => {
    expect(new CreateUserValidatorPipe()).toBeDefined();
  });

  it('should throw when login null', () => {
    const validator = new CreateUserValidatorPipe();

    expect(() =>
      validator.transform(
        { login: null, name: 'teste', timestamp: Number(new Date()) },
        { type: 'body' },
      ),
    ).toThrow(new CreateUserException('login is required'));
  });

  it('should throw when name null', () => {
    const validator = new CreateUserValidatorPipe();

    expect(() =>
      validator.transform(
        { login: 'teste', name: null, timestamp: Number(new Date()) },
        { type: 'body' },
      ),
    ).toThrowError(new CreateUserException('name is required'));
  });

  it('should throw when timestamp null', () => {
    const validator = new CreateUserValidatorPipe();

    expect(() =>
      validator.transform(
        { login: 'teste', name: 'teste', timestamp: null },
        { type: 'body' },
      ),
    ).toThrowError(new CreateUserException('timestamp is required'));
  });
});
