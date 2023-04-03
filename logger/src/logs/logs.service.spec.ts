import { MongooseModule, getModelToken } from '@nestjs/mongoose';
import { Test, TestingModule } from '@nestjs/testing';
import { config } from 'dotenv';
import Mongoose, { Model } from 'mongoose';
import { LogEntity, LogSchema } from './entities/log.entity';
import { LogsService } from './logs.service';
import { CreateLogDto } from './dto/create-log.dto';

config();

describe('LogsService', () => {
  let service: LogsService;
  let logModel: Model<LogEntity>;
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
          { schema: LogSchema, name: LogEntity.name },
        ]),
      ],
      providers: [LogsService],
    }).compile();

    service = module.get<LogsService>(LogsService);
    logModel = module.get(getModelToken(LogEntity.name));
  });

  afterAll(async () => {
    await logModel.deleteMany();
    await module.close();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should list all logs', async () => {
    const expected = await new logModel({
      _id: new Mongoose.Types.ObjectId(),
      action: 'create',
      payload: { teste: 'teste' },
      timestamp: Number(new Date()),
    }).save();

    const upDirection = 1;
    const logsList = await service.findAll(upDirection);

    const received = logsList.at(0);
    expect(logsList).toHaveLength(1);
    expect(received._id).toBe(expected.toObject()._id);
  });

  it('should list a log by id', async () => {
    const id = new Mongoose.Types.ObjectId();
    const expected = await new logModel({
      _id: id,
      action: 'create',
      payload: { teste: 'teste' },
      timestamp: Number(new Date()),
    }).save();

    const found = await service.findOne(id.toString());

    const received = found;
    expect(received._id).toBe(expected.toObject()._id);
  });

  it('should create a log', async () => {
    const toBeCreated: CreateLogDto = {
      action: 'create',
      payload: { teste: 'teste' },
      timestamp: Number(new Date()),
    };

    const created = await service.create(toBeCreated);

    expect(created).toBeDefined();
    expect(created._id).toBeDefined();
  });
});
