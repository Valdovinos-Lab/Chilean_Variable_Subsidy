function Data = compileOdeData(Data)

GuildInfo = Data.GuildInfo;

% New variables resized to avoid unnecessary computation and memory usage
Data.c = vertcat(Data.Guilds(GuildInfo.iProducerGuilds).c);
Data.r = vertcat(Data.Guilds(GuildInfo.iProducerGuilds).igr);
%Data.r = vertcat(Data.Guilds(GuildInfo.iProducerGuilds).newigrEx);
Data.bx = vertcat(Data.Guilds(GuildInfo.iConsumerGuilds).bx);
Data.ax = vertcat(Data.Guilds(GuildInfo.iFeederGuilds).ax); 
Data.x = vertcat(Data.Guilds(GuildInfo.iConsumerGuilds).mbr);
Data.omega = Data.omega(GuildInfo.iFeederGuilds,GuildInfo.iFoodGuilds);

%Data.B0 = Data.B0(GuildInfo.iFeederGuilds,GuildInfo.iFoodGuilds);%1500
%Data.B0 = Data.B0_1(GuildInfo.iFeederGuilds,GuildInfo.iFoodGuilds); %all 1500 except by birds
Data.B0 = Data.B0_6(GuildInfo.iFeederGuilds,GuildInfo.iFoodGuilds); %B0 by TL
%Data.B0 = Data.B0_opt(GuildInfo.iFeederGuilds,GuildInfo.iFoodGuilds); %randoms B0


%Data.B0 = Data.B0_3(GuildInfo.iFeederGuilds,GuildInfo.iFoodGuilds);
%%Ineficiencia en el consumo solo para herbivoros

Data.communityMatrix = Data.communityMatrix(GuildInfo.iFeederGuilds,GuildInfo.iFoodGuilds);

Data.d = Data.d(GuildInfo.iFeederGuilds,GuildInfo.iFoodGuilds);
%Data.d = Data.d_1(GuildInfo.iFeederGuilds,GuildInfo.iFoodGuilds); %d=corrected


Data.q = Data.q(GuildInfo.iFeederGuilds,GuildInfo.iFoodGuilds);
Data.e = Data.e(GuildInfo.iFeederGuilds,GuildInfo.iFoodGuilds);
Data.y = Data.y(GuildInfo.iFeederGuilds,GuildInfo.iFoodGuilds);

Data.B0_pow_q = Data.B0.^Data.q;
Data.B0_pow_q = Data.B0_pow_q.*Data.communityMatrix;

K = repmat(Data.K,[1,Data.nYearsFwd]);
Data.K = K;        
        
end
