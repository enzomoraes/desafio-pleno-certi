import { HttpException } from "@nestjs/common";

export default class LogNotFoundException extends HttpException {
  constructor(message: string) {
    super(message, 404);
  }
}
