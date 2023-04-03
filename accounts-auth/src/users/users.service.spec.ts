import { MongooseModule, getModelToken } from '@nestjs/mongoose';
import { Test, TestingModule } from '@nestjs/testing';
import { config } from 'dotenv';
import Mongoose, { Model } from 'mongoose';
import { CREATE, FIND_ALL, FIND_ONE, REMOVE, UPDATE } from '../_const';
import { LoggerService } from '../logger/logger.service';
import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserEntity, UserSchema } from './entities/user.entity';
import UserNotFoundException from './exceptions/UserNotFoundException';
import { UsersService } from './users.service';
config();

describe('UsersService', () => {
  let service: UsersService;
  let loggerService: jest.SpyInstance;
  let userModel: Model<UserEntity>;
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
      providers: [UsersService, LoggerService],
    }).compile();

    service = module.get<UsersService>(UsersService);
    userModel = module.get(getModelToken(UserEntity.name));
  });

  afterEach(async () => {
    await userModel.deleteMany();
    loggerService.mockClear();
  });

  beforeEach(() => {
    loggerService = jest
      .spyOn(module.get(LoggerService), 'createLog')
      .mockImplementation();
  });

  afterAll(async () => {
    await module.close();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should create an user', async () => {
    const toBeCreated: CreateUserDto = {
      login: 'login',
      name: 'teste',
      timestamp: Number(new Date()),
    };

    const created = await service.create(toBeCreated);

    expect(created).toBeDefined();
    expect(created._id).toBeDefined();

    expect(loggerService).toBeCalled();
    expect(loggerService).toBeCalledWith(toBeCreated, CREATE);
  });

  it('should update an user', async () => {
    const _id = new Mongoose.Types.ObjectId();

    const existing = await new userModel({
      _id,
      login: 'antes',
      name: 'antes',
      timestamp: Number(new Date()),
    }).save();

    const toBeUpdated: UpdateUserDto = {
      login: 'depois',
      name: 'depois',
      timestamp: Number(new Date()),
    };

    const updated = await service.update(existing.id, toBeUpdated);

    expect(updated).toBeDefined();
    expect(updated._id).toBeDefined();
    expect(updated.login).toBe(toBeUpdated.login);
    expect(updated.name).toBe(toBeUpdated.name);

    expect(loggerService).toBeCalled();
    expect(loggerService).toBeCalledWith(
      { id: _id.toString(), ...toBeUpdated },
      UPDATE,
    );
  });

  it('should list all users', async () => {
    const expected = await new userModel({
      _id: new Mongoose.Types.ObjectId(),
      login: 'login',
      name: 'teste',
      timestamp: Number(new Date()),
    }).save();

    const upDirection = 1;
    const logsList = await service.findAll(upDirection);

    const received = logsList.at(0);
    expect(logsList).toHaveLength(1);
    expect(received._id).toBe(expected.toObject()._id);

    expect(loggerService).toBeCalled();
    expect(loggerService).toBeCalledWith(
      { orderDirection: upDirection },
      FIND_ALL,
    );
  });

  it('should list one user by id', async () => {
    const id = new Mongoose.Types.ObjectId();
    const expected = await new userModel({
      _id: id,
      login: 'login',
      name: 'teste',
      timestamp: Number(new Date()),
    }).save();

    const received = await service.findOne(id.toString());
    expect(received).toBeDefined();
    expect(received._id).toBe(expected.toObject()._id);

    expect(loggerService).toBeCalled();
    expect(loggerService).toBeCalledWith({ id: id.toString() }, FIND_ONE);
  });

  it('should throw when id not found', async () => {
    const id = 'id inexistente';
    expect(async () => {
      await service.findOne(id.toString());
    }).rejects.toThrowError(
      new UserNotFoundException(`Could not find user of id ${id}`),
    );

    expect(loggerService).toBeCalled();
    expect(loggerService).toBeCalledWith({ id }, FIND_ONE);
  });

  it('should remove an user', async () => {
    const _id = new Mongoose.Types.ObjectId();

    await new userModel({
      _id,
      login: 'antes',
      name: 'antes',
      timestamp: Number(new Date()),
    }).save();

    await service.remove(_id.toString());

    expect(await userModel.find()).toHaveLength(0);

    expect(loggerService).toBeCalled();
    expect(loggerService).toBeCalledWith({ id: _id.toString() }, REMOVE);
  });
});
