import { Injectable } from '@nestjs/common';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { InjectModel } from '@nestjs/mongoose';
import { UserEntity } from './entities/user.entity';
import Mongoose, { Model } from 'mongoose';
import UserNotFoundException from './exceptions/UserNotFoundException';
import { generatePassword } from '../auth/generatePassword';
import { LoggerService } from '../logger/logger.service';
import { CREATE, FIND_ALL, FIND_ONE, REMOVE, UPDATE } from '../_const';

@Injectable()
export class UsersService {
  constructor(
    @InjectModel(UserEntity.name) private userModel: Model<UserEntity>,
    private loggerService: LoggerService,
  ) {}

  /**
   * This method creates an User
   * @param createUserDto
   * @returns the created user
   */
  create(createUserDto: CreateUserDto): Promise<UserEntity> {
    this.loggerService.createLog(createUserDto, CREATE);
    const password = generatePassword();

    const _id = new Mongoose.Types.ObjectId();
    const user = new this.userModel({ ...createUserDto, _id, password });
    return user.save();
  }

  /**
   * This method returns all created users and has an option to change the order
   * @param orderDirection of the query
   * @returns all users
   */
  findAll(orderDirection: -1 | 1): Promise<UserEntity[]> {
    this.loggerService.createLog({ orderDirection }, FIND_ALL);
    return this.userModel.find().sort({ timestamp: orderDirection });
  }

  /**
   * This method returns a user by id
   * @param id
   * @returns the found user
   */
  async findOne(id: string): Promise<UserEntity> {
    this.loggerService.createLog({ id }, FIND_ONE);

    const user = await this.userModel.findById(id).exec();
    if (!user) {
      throw new UserNotFoundException(`Could not find user of id ${id}`);
    }
    return user;
  }

  /**
   * This method updates an user by id
   * @param id
   * @param updateUserDto
   * @returns the updated user
   */
  async update(id: string, updateUserDto: UpdateUserDto): Promise<UserEntity> {
    this.loggerService.createLog({ id, ...updateUserDto }, UPDATE);

    const user = await this.userModel.findOneAndUpdate(
      { _id: id },
      { ...updateUserDto },
      { new: true },
    );
    if (!user)
      throw new UserNotFoundException(`Could not find user of id ${id}`);

    return user;
  }

  /**
   * This method removes an user by id
   * @param id
   * @returns void
   */
  async remove(id: string): Promise<void> {
    this.loggerService.createLog({ id }, REMOVE);

    const user = await this.userModel.findByIdAndDelete(id);
    if (!user)
      throw new UserNotFoundException(`Could not find user of id ${id}`);
    return;
  }
}
