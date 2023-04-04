import { MongooseModule, getModelToken } from '@nestjs/mongoose';
import CreateUserException from '../../users/exceptions/CreateUserException';
import { CreateUserValidatorPipe } from './create-user-validator.pipe';
import { UserEntity, UserSchema } from '../../users/entities/user.entity';
import { Test, TestingModule } from '@nestjs/testing';
import Mongoose, { Model } from 'mongoose';
import { config } from 'dotenv';
config();

describe('CreateUserValidatorPipe', () => {
  let userModel: Model<UserEntity>;
  let module: TestingModule;
  let pipe: CreateUserValidatorPipe;

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
      providers: [CreateUserValidatorPipe],
    }).compile();

    userModel = module.get(getModelToken(UserEntity.name));
    pipe = module.get(CreateUserValidatorPipe);
  });

  afterEach(async () => {
    await userModel.deleteMany();
  });

  afterAll(async () => {
    await module.close();
  });

  it('should be defined', () => {
    expect(pipe).toBeDefined();
  });

  it('should throw when login null', () => {

    expect(
      async () =>
        await pipe.transform(
          { login: null, name: 'teste', timestamp: Number(new Date()) },
          { type: 'body' },
        ),
    ).rejects.toThrow(new CreateUserException('login is required'));
  });

  it('should throw when name null', () => {

    expect(async () =>
      await pipe.transform(
        { login: 'teste', name: null, timestamp: Number(new Date()) },
        { type: 'body' },
      ),
    ).rejects.toThrowError(new CreateUserException('name is required'));
  });

  it('should throw when timestamp null', () => {

    expect(async () =>
      await pipe.transform(
        { login: 'teste', name: 'teste', timestamp: null },
        { type: 'body' },
      ),
    ).rejects.toThrowError(new CreateUserException('timestamp is required'));
  });

  it('should throw when login already exists', async () => {

    await new userModel({
      _id: new Mongoose.Types.ObjectId(),
      login: 'login',
      name: 'name',
      timestamp: Number(new Date()),
      password: 'pass',
    }).save();

    expect(async () =>
      await pipe.transform(
        { login: 'login', name: 'teste', timestamp: Number(new Date()) },
        { type: 'body' },
      ),
    ).rejects.toThrowError(
      new CreateUserException(
        'This login is already taken! Please, choose another one.',
      ),
    );
  });
});
