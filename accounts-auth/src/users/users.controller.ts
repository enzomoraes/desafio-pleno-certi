import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  UsePipes,
  UseGuards,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { CreateUserValidatorPipe } from '../pipes/create-user-validator/create-user-validator.pipe';
import { UserMapper } from './dto/mapper';

@Controller('users')
export class UsersController {
  private mapper = UserMapper();
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @UsePipes(CreateUserValidatorPipe)
  async create(@Body() createUserDto: CreateUserDto) {
    return this.mapper.toResponse(
      await this.usersService.create(createUserDto),
    );
  }

  @Get()
  async findAll(@Query('orderDirection') orderDirection: -1 | 1 = -1) {
    return this.mapper.toResponseList(
      await this.usersService.findAll(orderDirection),
    );
  }

  @Get(':id')
  async findOne(@Param('id') id: string) {
    return this.mapper.toResponse(await this.usersService.findOne(id));
  }

  @Patch(':id')
  async update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return this.mapper.toResponse(
      await this.usersService.update(id, updateUserDto),
    );
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.usersService.remove(id);
  }
}
