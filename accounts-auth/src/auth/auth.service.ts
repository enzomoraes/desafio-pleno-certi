import { Injectable } from '@nestjs/common';

@Injectable()
export class AuthService {
  constructor() {}

  async login(username: string, password: string): Promise<any> {}
}
