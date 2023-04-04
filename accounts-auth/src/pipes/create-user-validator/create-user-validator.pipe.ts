import { ArgumentMetadata, Injectable, PipeTransform } from '@nestjs/common';
import { CreateUserDto } from '../../users/dto/create-user.dto';
import CreateUserException from '../../users/exceptions/CreateUserException';
import { InjectModel } from '@nestjs/mongoose';
import { UserEntity } from '../../users/entities/user.entity';
import { Model } from 'mongoose';

@Injectable()
export class CreateUserValidatorPipe
  implements PipeTransform<CreateUserDto, Promise<CreateUserDto>>
{
  constructor(
    @InjectModel(UserEntity.name) private userModel: Model<UserEntity>,
  ) {}

  /**
   * This class validates log creation
   * @param value
   * @param metadata
   * @returns
   */
  async transform(value: CreateUserDto, metadata: ArgumentMetadata) {
    if (!value.login) {
      throw new CreateUserException('login is required');
    }

    if (!value.name) {
      throw new CreateUserException('name is required');
    }

    if (!value.timestamp) {
      throw new CreateUserException('timestamp is required');
    }

    const existingUser: UserEntity = await this.userModel
      .findOne({ login: value.login })
      .exec();
    
    if (existingUser) {
      throw new CreateUserException(
        'This login is already taken! Please, choose another one.',
      );
    }

    return value;
  }
}
