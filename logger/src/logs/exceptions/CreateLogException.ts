import { HttpException } from "@nestjs/common";

export default class CreateLogException extends HttpException {
  constructor(message: string) {
    super(message, 400);
  }
}
