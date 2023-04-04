import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

/**
 * This guard is responsible for applying @nestjs/passport strategy
 */
@Injectable()
export class JwtGuard extends AuthGuard('jwt') {}
