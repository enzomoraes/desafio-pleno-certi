import { MongooseModule } from '@nestjs/mongoose';
import { Test, TestingModule } from '@nestjs/testing';
import { LoggerService } from '../logger/logger.service';
import { UserEntity, UserSchema } from './entities/user.entity';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';

describe('UsersController', () => {
  let controller: UsersController;
  let module: TestingModule;

  beforeAll(async () => {
    module = await Test.createTestingModule({
      imports: [
        MongooseModule.forRoot(
          `mongodb://${process.env.MONGO_USER}:${process.env.MONGO_PASSWORD}@${process.env.MONGO_HOST}`,
          {
            dbName: 'testes',
          },
        ),
        MongooseModule.forFeature([
          { schema: UserSchema, name: UserEntity.name },
        ]),
      ],
      providers: [UsersController, UsersService, LoggerService],
    }).compile();

    controller = module.get<UsersController>(UsersController);
  });

  afterAll(async () => {
    await module.close();
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });
});
