import { HttpException } from '@nestjs/common';

export default class UserNotFoundException extends HttpException {
  constructor(message: string) {
    super(message, 404);
  }
}
