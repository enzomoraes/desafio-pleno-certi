import CreateLogException from '../../logs/exceptions/CreateLogException';
import { CreateLogValidatorPipe } from './create-log-validator.pipe';

describe('CreateLogValidatorPipe', () => {
  it('should be defined', () => {
    expect(new CreateLogValidatorPipe()).toBeDefined();
  });

  it('should throw when action null', () => {
    const validator = new CreateLogValidatorPipe();

    expect(() =>
      validator.transform(
        { action: null, payload: { id: {} }, timestamp: 1 },
        { type: 'body' },
      ),
    ).toThrow(new CreateLogException('action is required'));
  });

  it('should throw when payload null', () => {
    const validator = new CreateLogValidatorPipe();

    expect(() =>
      validator.transform(
        { action: 'create', payload: null, timestamp: 1 },
        { type: 'body' },
      ),
    ).toThrowError(new CreateLogException('payload is required'));
  });

  it('should throw when timestamp null', () => {
    const validator = new CreateLogValidatorPipe();

    expect(() =>
      validator.transform(
        { action: 'create', payload: { id: {} }, timestamp: null },
        { type: 'body' },
      ),
    ).toThrowError(new CreateLogException('timestamp is required'));
  });
});
