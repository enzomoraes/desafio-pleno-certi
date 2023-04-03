import { ArgumentMetadata, Injectable, PipeTransform } from '@nestjs/common';
import { CreateUserDto } from '../../users/dto/create-user.dto';
import CreateUserException from '../../users/exceptions/CreateUserException';

@Injectable()
export class CreateUserValidatorPipe
  implements PipeTransform<CreateUserDto, CreateUserDto>
{
  /**
   * This class validates log creation
   * @param value
   * @param metadata
   * @returns
   */
  transform(value: CreateUserDto, metadata: ArgumentMetadata) {
    if (!value.login) {
      throw new CreateUserException('login is required');
    }

    if (!value.name) {
      throw new CreateUserException('name is required');
    }

    if (!value.timestamp) {
      throw new CreateUserException('timestamp is required');
    }

    return value;
  }
}
