import { HttpException } from '@nestjs/common';

export default class CreateUserException extends HttpException {
  constructor(message: string) {
    super(message, 400);
  }
}
